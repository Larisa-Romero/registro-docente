# frozen_string_literal: true

module Reports
  class TraineeReport
    attr_reader :trainee, :degree, :funding_manager, :course

    def initialize(trainee)
      @trainee = trainee
      @degree = trainee.degrees.first
      @funding_manager = FundingManager.new(trainee)

      # In rails 6 we can't preload the `published_course`, because it is instance dependent. This is supported in rails 7.
      #  The association scope 'published_course' is instance dependent (the scope block takes an argument).
      #  Preloading instance dependent scopes is not supported.
      @course = Course.includes(:provider).find_by(uuid: trainee.course_uuid)
    end

    # rubocop:disable Naming/VariableNumber
    delegate :code, :name, to: :course, prefix: true, allow_nil: true
    delegate :country,
             :grade,
             :graduation_year,
             :other_grade,
             :subject,
             to: :degree,
             prefix: :degree_1,
             allow_nil: true
    delegate :additional_withdraw_reason,
             :course_duration_in_years,
             :ethnic_background,
             :first_names,
             :hesa_id,
             :middle_names,
             :postcode,
             :town_city,
             :trn,
             :withdraw_reason,
             to: :trainee,
             allow_nil: true

    def address_line_1
      trainee.address_line_one
    end

    def address_line_2
      trainee.address_line_two
    end
    # rubocop:enable Naming/VariableNumber

    def apply_id
      trainee.apply_application&.apply_id
    end

    def award_given_at
      return "Currently no data available in Register" if # TODO: move text to translation file
        trainee.awarded_at.blank? && trainee.hesa_record? && trainee.awarded?

      trainee.awarded_at&.iso8601
    end

    def award_standards_met_date
      trainee.outcome_date&.iso8601
    end

    def bursary_tier
      {
        "tier_one" => "Tier 1",
        "tier_two" => "Tier 2",
        "tier_three" => "Tier 3",
      }[trainee.bursary_tier]
    end

    def course_award
      return if trainee.course_uuid.blank? || course&.summary.blank?

      case trainee.study_mode
      when "part_time"
        course.summary.gsub(/(full time)/i, "part time")
      when "full_time"
        course.summary.gsub(/(part time)/i, "full time")
      end
    end

    def course_education_phase
      return EARLY_YEARS_ROUTE_NAME_PREFIX.humanize if trainee.early_years_route?

      trainee.course_education_phase&.upcase_first || course&.level&.capitalize
    end

    def course_full_or_part_time
      trainee.study_mode&.humanize
    end

    # rubocop:disable Naming/VariableNumber
    def course_itt_subject_1
      trainee.course_subject_one
    end

    def course_itt_subject_2
      trainee.course_subject_two
    end

    def course_itt_subject_3
      trainee.course_subject_three
    end
    # rubocop:enable Naming/VariableNumber

    def course_level
      trainee.undergrad_route? ? "undergrad" : "postgrad"
    end

    def course_maximum_age
      trainee.course_max_age
    end

    def course_minimum_age
      trainee.course_min_age
    end

    def course_qualification
      trainee.award_type
    end

    def course_subject_category
      trainee_allocation_subject(trainee.course_subject_one) || course_allocation_subject
    end

    def course_training_route
      I18n.t("activerecord.attributes.trainee.training_routes.#{trainee.training_route}")
    end

    def date_of_birth
      trainee.date_of_birth&.iso8601
    end

    def defer_date
      return "Not required by HESA so no data available in Register" if # TODO: move text to translation file
        trainee.defer_date.blank? && trainee.hesa_record? && trainee.deferred?

      trainee.defer_date&.iso8601
    end

    def degree_1_awarding_institution
      degree&.institution
    end

    def degree_1_type_non_uk
      degree&.non_uk_degree
    end

    def degree_1_type_uk
      degree&.uk_degree
    end

    def degree_1_uk_or_non_uk
      return if degree.blank?

      degree.locale_code.gsub("_", "-").gsub("uk", "UK")
    end

    def degrees
      trainee.degrees.map do |degree|
        [
          degree_1_uk_or_non_uk,
          degree.institution,
          degree.country,
          degree.subject,
          degree.uk_degree,
          degree.non_uk_degree,
          degree.grade,
          degree.other_grade,
          degree.graduation_year,
        ].map { |d| "\"#{d}\"" }.join(", ")
      end.join(" | ")
    end

    def disabilities
      trainee.disabilities.map do |disability|
        if disability.name == Diversities::OTHER
          trainee.trainee_disabilities.select { |x| x.disability_id == disability.id }.first.additional_disability
        else
          disability.name
        end
      end.join(", ")
    end

    def disability_disclosure
      return if trainee.disability_disclosure.blank?

      {
        "disabled" => "Has disabilities",
        "disability_not_provided" => "Not provided",
        "no_disability" => "No disabilities",
      }[trainee.disability_disclosure]
    end

    def diversity_disclosure
      return if trainee.diversity_disclosure.blank?

      trainee.diversity_disclosure == "diversity_disclosed" ? "TRUE" : "FALSE"
    end

    def email_address
      trainee.email
    end

    def employing_school_name
      trainee.employing_school_not_applicable? ? I18n.t(:not_applicable) : trainee.employing_school&.name
    end

    def employing_school_urn
      trainee.employing_school&.urn
    end

    def end_academic_year
      trainee.end_academic_cycle&.label
    end

    def ethnic_background_additional
      trainee.additional_ethnic_background
    end

    def ethnic_group
      I18n.t("components.confirmation.diversity.ethnic_groups.#{trainee.ethnic_group.presence || 'not_provided_ethnic_group'}")
    end

    def expected_end_date
      return "End date not required by HESA so no data available in Register" if # TODO: move text to translation file
        trainee.itt_end_date.blank? && trainee.hesa_record? && !trainee.awaiting_action?

      trainee.itt_end_date&.iso8601
    end

    def funding_method
      if trainee.applying_for_bursary?
        FUNDING_TYPE_ENUMS[:bursary]
      elsif trainee.applying_for_scholarship?
        FUNDING_TYPE_ENUMS[:scholarship]
      elsif trainee.applying_for_grant?
        FUNDING_TYPE_ENUMS[:grant]
      elsif [trainee.applying_for_bursary, trainee.applying_for_scholarship, trainee.applying_for_grant].include?(false)
        "not funded"
      elsif !funding_manager.funding_available?
        "not available"
      end
    end

    def funding_value
      if trainee.applying_for_bursary?
        funding_manager.bursary_amount || "data not available"
      elsif trainee.applying_for_scholarship?
        funding_manager.scholarship_amount || "data not available"
      elsif trainee.applying_for_grant?
        funding_manager.grant_amount || "data not available"
      end
    end

    def hesa_record_last_changed_at
      trainee.hesa_updated_at&.iso8601
    end

    def international_address
      Array(trainee.international_address.to_s.split(/[\r\n,]/)).join(", ").presence
    end

    def itt_start_date
      trainee.itt_start_date&.iso8601
    end

    def last_names
      trainee.last_name
    end

    def lead_school_name
      trainee.lead_school_not_applicable? ? I18n.t(:not_applicable) : trainee.lead_school&.name
    end

    def lead_school_urn
      trainee.lead_school&.urn
    end

    def nationality
      trainee.nationalities.pluck(:name).map(&:titleize).join(", ")
    end

    def number_of_degrees
      trainee.degrees.size
    end

    def provider_id
      trainee.provider&.code
    end

    def provider_name
      trainee.provider&.name
    end

    def provider_trainee_id
      trainee.trainee_id
    end

    def record_created_at
      trainee.created_at&.iso8601
    end

    def record_source
      {
        "manual" => "Manual",
        "apply" => "Apply",
        "dttp" => "DTTP",
        "hesa" => "HESA",
      }[trainee.derived_record_source]
    end

    def register_id
      trainee.slug
    end

    def register_record_last_changed_at
      trainee.updated_at&.iso8601
    end

    def return_from_deferral_date
      trainee.reinstate_date&.iso8601
    end

    def sex
      return if trainee.sex.blank?

      I18n.t("components.confirmation.personal_detail.sexes.#{trainee.sex}")
    end

    def start_academic_year
      trainee.start_academic_cycle&.label
    end

    def submitted_for_trn_at
      trainee.submitted_for_trn_at&.iso8601
    end

    def trainee_start_date
      trainee.trainee_start_date&.iso8601
    end

    def trainee_status
      StatusTag::View.new(trainee: trainee).status
    end

    def trainee_url
      "#{Settings.base_url}/trainees/#{trainee.slug}"
    end

    def training_initiative
      return if trainee.training_initiative.blank?

      I18n.t("activerecord.attributes.trainee.training_initiatives.#{trainee.training_initiative}")
    end

    def withdraw_date
      trainee.withdraw_date&.to_date&.iso8601
    end

  private

    def course_allocation_subject
      return if course.blank? || course.subjects.blank?

      subject = CalculateSubjectSpecialisms.call(subjects: course.subjects.pluck(:name))
        .values.map(&:first).first

      trainee_allocation_subject(subject)
    end

    def trainee_allocation_subject(subject)
      return if subject.blank?

      SubjectSpecialism.find_by("lower(name) = ?", subject.downcase)&.allocation_subject&.name
    end
  end
end