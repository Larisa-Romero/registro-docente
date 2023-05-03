variable "app_environment" {}
variable "azure_region_name" {
  default = "uksouth"
}
variable "namespace" {}
variable "app_docker_image" {}
variable "app_environment_variables" {}
variable "app_secrets" {}
variable "cluster" {}
variable "deploy_azure_backing_services" {}
#variable "webapp_startup_command" {}
variable "azure_resource_prefix" {}
variable "postgres_version" {}
variable "postgres_admin_password" { sensitive = true }
variable "postgres_admin_username" {}
variable "postgres_enable_high_availability" {
  default = false
}
variable "postgres_flexible_server_sku" {
  type    = string
  default = "B_Standard_B1ms"
}
variable "postgres_flexible_server_storage_mb" {
  type    = number
  default = 32768
}

variable "redis_capacity" {
  type    = number
  default = 1
}

variable "redis_family" {
  type    = string
  default = "C"
}

variable "redis_sku_name" {
  type    = string
  default = "Standard"
}

variable "redis_minimum_tls_version" {
  type    = string
  default = "1.2"
}

variable "redis_public_network_access_enabled" {
  type    = bool
  default = false
}

variable "app_resource_group_name" {}

# variable "webapp_memory_max" {}
# variable "worker_memory_max" {}
# variable "secondary_worker_memory_max" {}
# variable "clock_worker_memory_max" {}
# variable "webapp_replicas" {}
# variable "worker_replicas" {}
# variable "secondary_worker_replicas" {}
# variable "clock_worker_replicas" {}

variable "gov_uk_host_names" {
  default = []
  type    = list(any)
}

# Variables for Azure alerts
variable "enable_alerting" {}
variable "pg_actiongroup_name" {}
variable "pg_actiongroup_rg" {}
variable "pg_memory_threshold" {
  default = 75
}
variable "pg_cpu_threshold" {
  default = 60
}
variable "pg_storage_threshold" {
  default = 75
}
variable "redis_memory_threshold" {
  default = 60
}
variable "pdb_min_available" {
  type    = string
  default = null
}

variable "config_short" {}
variable "service_short" {}

# new for register

variable "service_name" {}

variable "worker_apps" {
  type    = map(any)
  default = {}
}
variable "main_app" {
  type    = map(any)
  default = {}
}
variable "probe_path" { default = [] }

variable "postgres_extensions" {
  default = null
}

variable "postgres_create_servicename_db" {
  default = false
}

variable "redis_cache_url" {}
variable "redis_queue_url" {}

# local.postgres_service_name

locals {
  app_config_name                      = "${var.service_name}-config-${var.app_environment}"
  app_secrets_name                     = "${var.service_name}-secrets-${var.app_environment}"
  backing_services_resource_group_name = "${local.current_cluster.cluster_resource_prefix}-bs-rg"
  database_host                        = var.deploy_azure_backing_services ? azurerm_postgresql_flexible_server.postgres-server[0].fqdn : local.postgres_service_name
  database_url                         = "postgres://postgres:${var.postgres_admin_password}@${local.database_host}:5432/${local.postgres_service_name}"
  hostname                             = local.current_cluster.dns_zone_prefix != null ? "${local.webapp_name}.${local.current_cluster.dns_zone_prefix}.teacherservices.cloud" : "${local.webapp_name}.teacherservices.cloud"
  postgres_dns_zone                    = local.current_cluster.dns_zone_prefix != null ? "${local.current_cluster.dns_zone_prefix}.internal.postgres.database.azure.com" : "production.internal.postgres.database.azure.com"
  postgres_server_name                 = "${var.azure_resource_prefix}-${var.service_short}-${var.app_environment}-psql"
  postgres_service_name                = "${var.service_name}-postgres-${var.app_environment}"

  postgres_db = var.postgres_create_servicename_db ? local.postgres_service_name : "postgres"

  #webapp_startup_command = var.webapp_startup_command == null ? null : ["/bin/sh", "-c", var.webapp_startup_command]
  webapp_name            = "${var.service_name}-${var.app_environment}"
  worker_name            = "${var.service_name}-worker-${var.app_environment}"
  vnet_name              = "${local.current_cluster.cluster_resource_prefix}-vnet"

  webapp_env_variables = merge(
    var.app_environment_variables
  )

  webapp_env_variables_hash = sha1(join("-", [for k, v in local.webapp_env_variables : "${k}:${v}"]))

  app_secrets = merge(
    var.app_secrets,
    {
      DATABASE_URL        = local.database_url
      BLAZER_DATABASE_URL = local.database_url
      REDIS_URL           = "${var.redis_queue_url}"
      REDIS_CACHE_URL     = "${var.redis_cache_url}"
    }
  )
  # Create a unique name based on the values to force recreation when they change
  app_secrets_hash = sha1(join("-", [for k, v in local.app_secrets : "${k}:${v}" if v != null]))

  cluster = {
    cluster1 = {
      cluster_resource_group_name = "s189d01-tsc-dv-rg"
      cluster_resource_prefix     = "s189d01-tsc-cluster1"
      dns_zone_prefix             = "cluster1.development"
      cpu_min                     = 0.1
    }
    cluster2 = {
      cluster_resource_group_name = "s189d01-tsc-dv-rg"
      cluster_resource_prefix     = "s189d01-tsc-cluster2"
      dns_zone_prefix             = "cluster2.development"
      cpu_min                     = 0.1
    }
    cluster3 = {
      cluster_resource_group_name = "s189d01-tsc-dv-rg"
      cluster_resource_prefix     = "s189d01-tsc-cluster3"
      dns_zone_prefix             = "cluster3.development"
      cpu_min                     = 0.1
    }
    cluster4 = {
      cluster_resource_group_name = "s189d01-tsc-dv-rg"
      cluster_resource_prefix     = "s189d01-tsc-cluster4"
      dns_zone_prefix             = "cluster4.development"
      cpu_min                     = 0.1
    }
    cluster5 = {
      cluster_resource_group_name = "s189d01-tsc-dv-rg"
      cluster_resource_prefix     = "s189d01-tsc-cluster5"
      dns_zone_prefix             = "cluster5.development"
      cpu_min                     = 0.1
    }
    cluster6 = {
      cluster_resource_group_name = "s189d01-tsc-dv-rg"
      cluster_resource_prefix     = "s189d01-tsc-cluster6"
      dns_zone_prefix             = "cluster6.development"
      cpu_min                     = 0.1
    }
    test = {
      cluster_resource_group_name = "s189t01-tsc-ts-rg"
      cluster_resource_prefix     = "s189t01-tsc-test"
      dns_zone_prefix             = "test"
      cpu_min                     = 0.1
    }
    platform-test = {
      cluster_resource_group_name = "s189t01-tsc-pt-rg"
      cluster_resource_prefix     = "s189t01-tsc-platform-test"
      dns_zone_prefix             = "platform-test"
      cpu_min                     = 0.1
    }
    production = {
      cluster_resource_group_name = "s189p01-tsc-pd-rg"
      cluster_resource_prefix     = "s189p01-tsc-production"
      dns_zone_prefix             = null
      cpu_min                     = 1
    }
  }
  current_cluster = local.cluster[var.cluster]
  cluster_name    = "${local.current_cluster.cluster_resource_prefix}-aks"
}
