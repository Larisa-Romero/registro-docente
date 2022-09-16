# frozen_string_literal: true

module Trainees
  class CreateFromHpittCsv
    include ServicePattern
    include HasDiversityAttributes
    include HasCourseAttributes

    class Error < StandardError; end

    TRAINING_ROUTES = {
      "Assessment only" => TRAINING_ROUTE_ENUMS[:assessment_only],
      "Early years (assessment only)" => TRAINING_ROUTE_ENUMS[:early_years_assessment_only],
      "Early years (postgrad)" => TRAINING_ROUTE_ENUMS[:early_years_postgrad],
      "Early years (salaried)" => TRAINING_ROUTE_ENUMS[:early_years_salaried],
      "Early years (undergrad)" => TRAINING_ROUTE_ENUMS[:early_years_undergrad],
      "Opt-in (undergrad)" => TRAINING_ROUTE_ENUMS[:opt_in_undergrad],
      "Provider-led (postgrad)" => TRAINING_ROUTE_ENUMS[:provider_led_postgrad],
      "Provider-led (undergrad)" => TRAINING_ROUTE_ENUMS[:provider_led_undergrad],
      "School direct (fee funded)" => TRAINING_ROUTE_ENUMS[:school_direct_tuition_fee],
      "School direct (salaried)" => TRAINING_ROUTE_ENUMS[:school_direct_salaried],
      "Teaching apprenticeship (postgrad)" => TRAINING_ROUTE_ENUMS[:pg_teaching_apprenticeship],
    }.freeze

    INITIATIVES = {
      "Future Teaching Scholars" => ROUTE_INITIATIVES_ENUMS[:future_teaching_scholars],
      "Maths and Physics Chairs programme / Researchers in Schools" => ROUTE_INITIATIVES_ENUMS[:maths_physics_chairs_programme_researchers_in_schools],
      "Now Teach" => ROUTE_INITIATIVES_ENUMS[:now_teach],
      "Transition to Teach" => ROUTE_INITIATIVES_ENUMS[:transition_to_teach],
      "Troops to Teachers" => ROUTE_INITIATIVES_ENUMS[:troops_to_teachers],
      "Not on a training initiative" => ROUTE_INITIATIVES_ENUMS[:no_initiative],
    }.freeze

    def initialize(provider:, csv_row:)
      @csv_row = csv_row
      @provider = provider
      @trainee = @provider.trainees.find_or_initialize_by(trainee_id: csv_row["Provider trainee ID"])
    end

    def call
      trainee.assign_attributes(mapped_attributes)
      Trainees::SetAcademicCycles.call(trainee: trainee)

      if trainee.save!
        ::Degrees::CreateFromHpittCsv.call(
          trainee: trainee,
          csv_row: csv_row.to_hash.compact.select { |column_name, _| column_name.start_with?("Degree:") },
        )
      end

      validate_and_save_progress
    end

  private

    attr_reader :csv_row, :trainee, :provider

    def mapped_attributes
      {
        record_source: RecordSources::MANUAL,
        region: csv_row["Region"],
        training_route: training_route,
        first_names: csv_row["First names"],
        middle_names: csv_row["Middle names"],
        last_name: csv_row["Last names"],
        sex: sex,
        date_of_birth: Date.parse(csv_row["Date of birth"]),
        nationality_ids: nationality_ids,
        email: csv_row["Email"],
        training_initiative: training_initiative,
        employing_school_id: employing_school_id,
        lead_school_id: lead_school_id,
        course_uuid: course_uuid,
      }.merge(address_attributes)
       .merge(ethnicity_and_disability_attributes)
       .merge(course_attributes)
    end

    def address_attributes
      if csv_row["Outside UK address"].present?
        {
          locale_code: Trainee.locale_codes[:non_uk],
          international_address: csv_row["Outside UK address"],
        }
      else
        {
          locale_code: Trainee.locale_codes[:uk],
          address_line_one: csv_row["UK address: Line 1"],
          address_line_two: csv_row["UK address: Line 2"],
          town_city: csv_row["UK address: town or city"],
          postcode: postcode,
        }
      end
    end

    def postcode
      raw_postcode = csv_row["UK Address 1: Postcode"]
      return if raw_postcode.blank?

      UKPostcode.parse(raw_postcode.gsub(/\W/, "")).to_s
    end

    def ethnic_background
      Hesa::CodeSets::Ethnicities::NAME_MAPPING[csv_row["Ethnicity"]]
    end

    def disabilities
      disabilities = csv_row["Disabilities"].split(",").map(&:strip)
      disabilities.map { |disability| Hesa::CodeSets::Disabilities::NAME_MAPPING[disability] }.compact
    end

    def itt_start_date
      csv_row["Course ITT start date"]
    end

    def itt_end_date
      csv_row["Course Expected End Date"]
    end

    def trainee_start_date
      csv_row["Trainee start date"]
    end

    def training_route
      hpitt_trainee? ? TRAINING_ROUTE_ENUMS[:hpitt_postgrad] : TRAINING_ROUTES[csv_row["Training route"]]
    end

    def training_initiative
      hpitt_trainee? ? ROUTE_INITIATIVES_ENUMS[:no_initiative] : INITIATIVES[csv_row["Funding: Training Initiatives"]]
    end

    def sex
      if csv_row["Sex"] == Diversities::NOT_PROVIDED
        "sex_not_provided"
      else
        csv_row["Sex"].downcase
      end
    end

    def nationality_ids
      nationalities = csv_row["Nationality"].split(",").compact
      nationalities.map { |nationality| Nationality.find_by!(name: nationality.strip.downcase) }.map(&:id)
    end

    def course_education_phase
      csv_row["Course education phase"].downcase
    end

    def course_subject_one_name
      course_subject_name("Course ITT subject 1")
    end

    def course_subject_two_name
      course_subject_name("Course ITT subject 2")
    end

    def course_subject_three_name
      course_subject_name("Course ITT Subject 3")
    end

    def course_subject_name(field)
      course_subject = csv_row[field]
      return if course_subject.blank?

      subject_specialism = SubjectSpecialism.where("lower(name) = ?", course_subject.downcase).first

      if subject_specialism.present?
        subject_specialism.name
      else
        raise(Error, "Course subject not recognised: #{course_subject}")
      end
    end

    def course_age_range
      age_range = csv_row["Course age range"].split(" to ").map(&:to_i)

      if valid_age_ranges.include?(age_range)
        age_range
      else
        raise(Error, "Course age range not recognised: #{age_range}")
      end
    end

    def valid_age_ranges
      Set.new.tap do |set|
        AgeRange.constants.each do |constant|
          set.add(AgeRange.const_get(constant))
        end
      end
    end

    def study_mode
      csv_row["Course study mode"].downcase.gsub("-", "_")
    end

    def employing_school_id
      School.find_by(urn: csv_row["Employing school URN"])&.id
    end

    def lead_school_id
      School.lead_only.find_by(urn: csv_row["Lead school URN"])&.id
    end

    def course_uuid
      course_code = csv_row["Publish Course Code"]
      return if course_code.blank?

      course = provider.courses.find_by(code: course_code)
      raise(Error, "Course UUID not recognised for provider: #{course_code}") if course.nil?

      course.uuid
    end

    def hpitt_trainee?
      @provider.code == "HPITT"
    end

    def validate_and_save_progress
      Submissions::TrnValidator.new(trainee: trainee).validators.each do |section, validator|
        section_valid = validator[:form].constantize.new(trainee).valid?
        trainee.progress.public_send("#{section}=", section_valid)
      end

      trainee.save!
    end
  end
end
