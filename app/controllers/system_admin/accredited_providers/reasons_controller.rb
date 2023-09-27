# frozen_string_literal: true

module SystemAdmin
  module AccreditedProviders
    class ReasonsController < ApplicationController
      before_action :enforce_feature_flag

      def edit
        @change_accredited_provider_form = ChangeAccreditedProviderForm.new(trainee, step: :reasons)
      end

      def update
        @change_accredited_provider_form = ChangeAccreditedProviderForm.new(
          trainee,
          params: update_params,
          user: current_user,
          step: :reasons,
        )

        if @change_accredited_provider_form.stash
          redirect_to(trainee_accredited_providers_confirmations_path(trainee_id: params[:trainee_id]))
        else
          render(:edit)
        end
      end

    private

      def enforce_feature_flag
        redirect_to(not_found_path) unless FeatureService.enabled?(:change_accredited_provider)
      end

      def trainee
        @trainee ||= Trainee.find(params[:trainee_id])
      end

      def update_params
        params
          .require(:system_admin_change_accredited_provider_form)
          .permit(:audit_comment, :zendesk_ticket_url)
      end
    end
  end
end
