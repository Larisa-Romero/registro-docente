# frozen_string_literal: true

class CalculateBursary
  class << self
    # Returns true/false if there are any bursaries available for a given route.
    def available_for_route?(route)
      raise_if_route_not_recognised!(route)

      Bursary.find_by(training_route: route)&.bursary_subjects.present?
    end

    # Returns the amount in pounds of bursary available for a given route/subject combo.
    def for_route_and_subject(route, subject)
      raise_if_route_not_recognised!(route)

      # Bursaries are awarded based on the allocation subject for a given
      # subject specialism.
      allocation_subject = SubjectSpecialism.find_by!(name: subject).allocation_subject
      allocation_subject.bursaries.find_by(training_route: route)&.amount
    end

  private

    def raise_if_route_not_recognised!(route)
      raise "Training route '#{route}' not recognised" unless TRAINING_ROUTE_ENUMS[route]
    end
  end
end
