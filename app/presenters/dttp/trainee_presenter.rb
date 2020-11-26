# frozen_string_literal: true

module Dttp
  class TraineePresenter
    FEMALE_GENDER_CODE = 1
    MALE_GENDER_CODE = 2

    delegate_missing_to :trainee

    attr_reader :trainee

    def initialize(trainee:)
      @trainee = trainee
    end

    def contact_params
      {
        "firstname" => trainee.first_names,
        "lastname" => trainee.last_name,
        "address1_line1" => trainee.address_line_one,
        "address1_line2" => trainee.address_line_two,
        "address1_line3" => trainee.town_city,
        "address1_postalcode" => trainee.postcode,
        "birthdate" => trainee.date_of_birth.to_s,
        "emailaddress1" => trainee.email,
        "gendercode" => gender_code,
        "mobilephone" => trainee.phone_number,
        "dfe_EthnicityId@odata.bind" => "/dfe_ethnicities(#{dttp_ethnicity_id})",
        "dfe_DisibilityId@odata.bind" => "/dfe_disabilities(#{dttp_disability_id})",
      }
    end

    def placement_assignment_params
      programme_details_params.merge(degree.uk_degree ? uk_degree_params : non_uk_degree_params)
    end

  private

    def programme_details_params
      {
        "dfe_programmestartdate" => trainee.programme_start_date.in_time_zone.iso8601,
        "dfe_ContactId@odata.bind" => "/contacts(#{trainee.dttp_id})",
        "dfe_CoursePhaseId@odata.bind" => "/dfe_coursephases(#{dttp_course_phase_id})",
        "dfe_ITTSubject1Id@odata.bind" => "/dfe_subjects(#{dttp_programme_subject_id})",
      }
    end

    def uk_degree_params
      {
        "dfe_SubjectofUGDegreeId@odata.bind" => "/dfe_jacses(#{dttp_degree_subject_id})",
        "dfe_AwardingInstitutionId@odata.bind" => "/accounts(#{dttp_degree_institution_id})",
        "dfe_ClassofUGDegreeId@odata.bind" => "/dfe_classofdegrees(#{dttp_degree_class_id})",
      }
    end

    def non_uk_degree_params
      {
        "dfe_SubjectofUGDegreeId@odata.bind" => "/dfe_jacses(#{dttp_degree_subject_id})",
        "dfe_CountryofStudyId@odata.bind" => "/dfe_countries(#{dttp_degree_country_id})",
      }
    end

    def gender_code
      trainee.male? ? MALE_GENDER_CODE : FEMALE_GENDER_CODE
    end

    def dttp_disability
      if trainee_disabled?
        disabilities = trainee.disabilities.pluck(:name)
        disabilities.size == 1 ? disabilities.first : Diversities::MULTIPLE_DISABILITIES
      elsif trainee_not_disabled?
        Diversities::NO_KNOWN_DISABILITY
      else
        Diversities::NOT_PROVIDED
      end
    end

    def diversity_disclosed?
      trainee.diversity_disclosure == Diversities::DIVERSITY_DISCLOSURE_ENUMS[:diversity_disclosed]
    end

    def trainee_disabled?
      trainee.disability_disclosure == Diversities::DISABILITY_DISCLOSURE_ENUMS[:disabled]
    end

    def trainee_not_disabled?
      trainee.disability_disclosure == Diversities::DISABILITY_DISCLOSURE_ENUMS[:not_disabled]
    end

    def degree
      @degree ||= trainee.degrees.order(:created_at).first # assuming first is most relevant - TBC
    end

    def dttp_ethnicity_id
      key = diversity_disclosed? ? trainee.ethnic_background : Diversities::NOT_PROVIDED
      CodeSets::Ethnicities::MAPPING.dig(key, :entity_id)
    end

    def dttp_disability_id
      key = diversity_disclosed? ? dttp_disability : Diversities::NOT_PROVIDED
      CodeSets::Disabilities::MAPPING.dig(key, :entity_id)
    end

    def dttp_programme_subject_id
      Dttp::CodeSets::ProgrammeSubjects::MAPPING.dig(trainee.subject, :entity_id)
    end

    def dttp_course_phase_id
      Dttp::CodeSets::AgeRanges::MAPPING.dig(trainee.age_range, :entity_id)
    end

    def dttp_degree_subject_id
      Dttp::CodeSets::DegreeSubjects::MAPPING.dig(degree.subject, :entity_id)
    end

    def dttp_degree_institution_id
      Dttp::CodeSets::Institutions::MAPPING.dig(degree.institution, :entity_id)
    end

    def dttp_degree_class_id
      Dttp::CodeSets::Grades::MAPPING.dig(degree.grade, :entity_id)
    end

    def dttp_degree_country_id
      Dttp::CodeSets::Countries::MAPPING.dig(degree.country, :entity_id)
    end
  end
end
