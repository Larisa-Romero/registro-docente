# frozen_string_literal: true

module Dttp
  class PlacementAssignment < ApplicationRecord
    self.table_name = "dttp_placement_assignments"

    belongs_to :trainee, foreign_key: :contact_dttp_id, primary_key: :dttp_id, inverse_of: :placement_assignments, optional: true

    has_one :dormant_period, foreign_key: :placement_assignment_dttp_id, primary_key: :dttp_id, inverse_of: :placement_assignment

    validates :response, presence: true

    def route_dttp_id
      response["_dfe_routeid_value"]
    end

    def lead_school_id
      response["_dfe_leadschoolid_value"]
    end

    def employing_school_id
      response["_dfe_employingschoolid_value"]
    end

    def study_mode_id
      response["_dfe_studymodeid_value"]
    end
  end
end
