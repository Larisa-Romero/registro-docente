# frozen_string_literal: true

module Trainees
  module Diversity
    class DisabilityDetailsController < ApplicationController
      def edit
        authorize trainee
        disabilities
        @disability_detail = Diversities::DisabilityDetail.new(trainee: trainee)
      end

      def update
        authorize trainee
        disabilities
        updater = Diversities::DisabilityDetails::Update.call(
          trainee: trainee,
          attributes: disability_detail_params,
        )

        if updater.successful?
          redirect_to(trainee_diversity_disability_detail_confirm_path(trainee))
        else
          @disability_detail = updater.disability_detail
          render :edit
        end
      end

    private

      def trainee
        @trainee ||= Trainee.find(params[:trainee_id])
      end

      def disabilities
        @disabilities ||= Disability.all
      end

      def disability_detail_params
        return { disability_ids: nil } if params[:diversities_disability_detail].blank?

        params.require(:diversities_disability_detail).permit(disability_ids: [])
      end
    end
  end
end
