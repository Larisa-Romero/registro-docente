# frozen_string_literal: true

module ApiRoutes
  def self.extended(router)
    router.instance_exec do
      namespace :api, path: "api/:api_version", api_version: /v[.0-9]+/ do
        resources :trainees, only: %i[index show], controller: "trainees", constraints: RouteConstraints::RegisterApiConstraint
        resource :info, only: :show, controller: "info", constraints: RouteConstraints::RegisterApiConstraint
        resource :guide, only: :show, controller: "guide", constraints: RouteConstraints::RegisterApiConstraint
        match "*url" => "base#not_found", via: :all
      end
    end
  end
end
