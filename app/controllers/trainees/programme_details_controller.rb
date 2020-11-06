module Trainees
  class ProgrammeDetailsController < ApplicationController
    PROGRAMME_START_DATE_CONVERSION = {
      "programme_start_date(3i)" => "day",
      "programme_start_date(2i)" => "month",
      "programme_start_date(1i)" => "year",
    }.freeze

    PROGRAMME_DETAILS_PARAMS_KEYS = %i[subject
                                       main_age_range
                                       additional_age_range].freeze

    def edit
      trainee
      @programme_detail = ProgrammeDetail.new(trainee: trainee)
    end

    def update
      updater = ProgrammeDetails::Update.call(trainee: trainee,
                                              attributes: programme_details_params)
      if updater.successful?
        redirect_to trainee_path(trainee)
      else
        @programme_detail = updater.programme_detail
        render :edit
      end
    end

  private

    def trainee
      @trainee ||= Trainee.find(params[:trainee_id])
    end

    def programme_details_params
      params.require(:programme_detail).permit(
        *PROGRAMME_DETAILS_PARAMS_KEYS,
      ).except(*PROGRAMME_START_DATE_CONVERSION.keys)
      .merge(programme_start_date_params)
    end

    def programme_start_date_params
      params.require(:programme_detail).except(
        *PROGRAMME_DETAILS_PARAMS_KEYS,
      ).permit(*PROGRAMME_START_DATE_CONVERSION.keys)
      .transform_keys { |key| PROGRAMME_START_DATE_CONVERSION[key] }
    end
  end
end
