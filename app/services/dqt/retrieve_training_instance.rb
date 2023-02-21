# frozen_string_literal: true

module Dqt
  class NoTrainingInstanceError < StandardError; end

  class RetrieveTrainingInstance
    include ServicePattern

    def initialize(trainee:)
      @trainee = trainee
    end

    def call
      raise(NoTrainingInstanceError) if training_instances.blank? || training_instance.nil?

      training_instance
    end

    attr_reader :trainee

  private

    def training_instance
      @training_instance ||= training_instances.find do |training|
        training.dig("provider", "ukprn") == trainee.provider.ukprn &&
          training["programmeType"] == programme_type(trainee)
      end
    end

    def programme_type(trainee)
      Dqt::Params::TrnRequest::PROGRAMME_TYPE[trainee.training_route]
    end

    def training_instances
      @training_instances ||= RetrieveTeacher.call(trainee:)["initialTeacherTraining"]
    end
  end
end