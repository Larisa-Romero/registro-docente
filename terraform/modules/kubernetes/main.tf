resource "kubernetes_deployment" "webapp" {
  metadata {
    name      = local.webapp_name
    namespace = var.namespace
  }
  spec {
    replicas = var.main_app.main["replicas"]
    selector {
      match_labels = {
        app = local.webapp_name
      }
    }
    template {
      metadata {
        labels = {
          app = local.webapp_name
        }
      }
      spec {
        node_selector = {
          "teacherservices.cloud/node_pool" = "applications"
          "kubernetes.io/os"                = "linux"
        }
        container {
          name    = local.webapp_name
          image   = var.app_docker_image
          command = try(slice(var.main_app.main["startup_command"], 0, 1), null)
          args    = try(slice(var.main_app.main["startup_command"], 1, length(var.main_app.main["startup_command"])), null)

          # Check performed to ensure the application is available. If it fails the current pod is killed and a new one created.
          dynamic "liveness_probe" {
            for_each = var.main_app.main["probe_path"]

            content {
              http_get {
                path = liveness_probe.value
                port = 3000
              }
              failure_threshold = 10
              period_seconds    = 1
              timeout_seconds   = 10
              }
          }
          dynamic "startup_probe" {
            for_each = var.main_app.main["probe_path"]

            content {
              http_get {
                path = startup_probe.value
                port = 3000
              }
              failure_threshold = 24
              period_seconds    = 5
              }
          }
          env_from {
            config_map_ref {
              name = kubernetes_config_map.app_config.metadata.0.name
            }
          }
          env_from {
            secret_ref {
              name = kubernetes_secret.app_secrets.metadata.0.name
            }
          }
          resources {
            requests = {
              cpu    = local.current_cluster.cpu_min
              memory = var.main_app.main["memory_max"]
            }
            limits = {
              cpu    = 1
              memory = var.main_app.main["memory_max"]
            }
          }
          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "webapp" {
  metadata {
    name      = local.webapp_name
    namespace = var.namespace
  }
  spec {
    type = "ClusterIP"
    port {
      port        = 80
      target_port = 3000
    }
    selector = {
      app = local.webapp_name
    }
  }
}

resource "kubernetes_config_map" "app_config" {
  metadata {
    name      = "${local.app_config_name}-${local.webapp_env_variables_hash}"
    namespace = var.namespace
  }
  data = local.webapp_env_variables
}

resource "kubernetes_secret" "app_secrets" {
  metadata {
    name      = "${local.app_secrets_name}-${local.app_secrets_hash}"
    namespace = var.namespace
  }
  data = local.app_secrets
}

resource "kubernetes_ingress_v1" "webapp" {
  wait_for_load_balancer = true
  metadata {
    name      = local.webapp_name
    namespace = var.namespace
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = local.hostname
      http {
        path {
          backend {
            service {
              name = kubernetes_service.webapp.metadata[0].name
              port {
                number = kubernetes_service.webapp.spec[0].port[0].port
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "webapp-svc" {
  for_each = toset(var.gov_uk_host_names)

  wait_for_load_balancer = true
  metadata {
    name      = each.value
    namespace = var.namespace
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = each.value
      http {
        path {
          backend {
            service {
              name = kubernetes_service.webapp.metadata[0].name
              port {
                number = kubernetes_service.webapp.spec[0].port[0].port
              }
            }
          }
        }
      }
    }
  }
}