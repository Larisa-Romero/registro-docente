# frozen_string_literal: true

module Trainees
  class TimelinesController < ApplicationController
    def show
      authorize trainee
      render layout: "trainee_record"
    end

  private

    def trainee
      @trainee ||= Trainee.from_param(params[:trainee_id])
    end
  end
end
