# frozen_string_literal: true

require "rails_helper"

module Trainees
  describe CreateFromHpittCsv do
    include SeedHelper
    let!(:provider) { create(:provider, :teach_first) }
    let!(:academic_cycle) { AcademicCycle.current }
    let(:urn) { "0123456" }

    let(:csv_row) {
      {
        "Provider trainee ID" => "12345",
        "Region" => "South West",
        "First names" => "Bob",
        "Middle name" => "B",
        "Last name" => "Robertson",
        "Date of birth" => "03/03/1996 00:00:00",
        "Sex" => "Male",
        "Nationality" => "british",
        "UK address: Line 1" => "1 Road",
        "UK address: Line 2" => "",
        "UK address: town or city" => "London",
        "UK Address 1: Postcode" => "SW1P 3BT",
        "Outside UK address" => "",
        "Email"	=> "bob@example.com",
        "Ethnicity"	=> "Not provided",
        "Disabilities" => "Not provided",
        # Not sure why we're asking for this?
        "Course level" => "Postgraduate",
        "Course education phase" => "Secondary",
        "Course age range" => "11 to 16",
        "Course ITT subject 1" => "Biology",
        "Course ITT subject 2" => "",
        "Course ITT Subject 3" => "",
        "Course study mode" => "full-time",
        "Course ITT start date" => "2022-09-09",
        "Course ITT end date" => "2023-07-31",
        "Trainee start date" => "2022-09-09",
        "Employing school URN" => urn,
        "Degree: country" => "United Kingdom",
        "Degree: subjects" => "History",
        "Degree: UK degree types" => "Bachelor of Arts",
        "Degree: UK awarding institution"	=> "University of Birmingham",
        "Degree: UK grade" => "Upper second-class honours (2:1)",
        "Degree: Non-UK degree types" => "",
        "Degree: graduation year" => "2021",
      }
    }

    let!(:course_allocation_subject) do
      create(:subject_specialism, name: CourseSubjects::BIOLOGY).allocation_subject
    end

    subject(:trainee) { Trainee.first }

    before do
      generate_seed_nationalities
      generate_seed_disabilities
      create(:school, urn: urn)
      create(:subject_specialism, name: "primary teaching")
    end

    describe "#call" do
      before do
        described_class.call(csv_row: csv_row)
      end

      it "updates the Trainee ID, route, region and record_source" do
        expect(trainee.trainee_id).to eq(csv_row["Provider trainee ID"])
        expect(trainee.record_source).to eq(RecordSources::MANUAL)
        expect(trainee.training_route).to eq(TRAINING_ROUTE_ENUMS[:hpitt_postgrad])
        expect(trainee.region).to eq(csv_row["Region"])
      end

      it "updates the trainee's personal details" do
        expect(trainee.first_names).to eq(csv_row["First names"])
        expect(trainee.middle_names).to eq(csv_row["Middle name"])
        expect(trainee.last_name).to eq(csv_row["Last name"])
        expect(trainee.gender).to eq("male")
        expect(trainee.date_of_birth).to eq(Date.parse(csv_row["Date of birth"]))
        expect(trainee.nationalities.pluck(:name)).to include("british")
        expect(trainee.email).to eq(csv_row["Email"])
        expect(trainee.locale_code).to eq("uk")
        expect(trainee.address_line_one).to eq("1 Road")
        expect(trainee.town_city).to eq("London")
        expect(trainee.postcode).to eq("SW1P 3BT")
      end

      it "updates trainee's course details" do
        expect(trainee.course_allocation_subject).to eq(course_allocation_subject)
        expect(trainee.course_education_phase).to eq(COURSE_EDUCATION_PHASE_ENUMS[:secondary])
        expect(trainee.course_subject_one).to eq(::CourseSubjects::BIOLOGY)
        expect(trainee.course_subject_two).to be_nil
        expect(trainee.course_subject_three).to be_nil
        expect(trainee.course_age_range).to eq(AgeRange::ELEVEN_TO_SIXTEEN)
        expect(trainee.study_mode).to eq("full_time")
        expect(trainee.itt_start_date).to eq(Date.parse(csv_row["Course ITT start date"]))
        expect(trainee.itt_end_date).to eq(Date.parse(csv_row["Course ITT end date"]))
        expect(trainee.start_academic_cycle).to eq(academic_cycle)
        expect(trainee.end_academic_cycle).to eq(academic_cycle)
        expect(trainee.trainee_start_date).to eq(Date.parse(csv_row["Trainee start date"]))
      end

      it "updates the trainee's school and training details" do
        expect(trainee.employing_school.urn).to eq(urn)
        expect(trainee.training_initiative).to eq(ROUTE_INITIATIVES_ENUMS[:no_initiative])
      end

      it "creates the trainee's degree" do
        degree = trainee.degrees.last
        expect(degree.locale_code).to eq("uk")
        expect(degree.uk_degree).to eq("Bachelor of Arts")
        expect(degree.non_uk_degree).to be_nil
        expect(degree.subject).to eq("History")
        expect(degree.institution).to eq("University of Birmingham")
        expect(degree.graduation_year).to eq(2021)
        expect(degree.grade).to eq("Upper second-class honours (2:1)")
        expect(degree.other_grade).to be_nil
        expect(degree.country).to be_nil
      end
    end

    context "when the degree institution UKPRN is provided" do
      before do
        csv_row.merge!({ "Degree: UK awarding institution" => "10007163" })
        described_class.call(csv_row: csv_row)
      end

      it "create's the trainee's degree with the correct institution" do
        expect(trainee.degrees.first.institution).to eq("University of Warwick")
      end
    end

    context "when the degree is not from the UK" do
      before do
        csv_row.merge!({
          "Degree: country" => "Germany",
          "Degree: subjects" => "Akkadian language",
          "Degree: UK degree types" => "",
          "Degree: UK awarding institution"	=> "",
          "Degree: UK grade" => "",
          "Degree: Non-UK degree types" => "Bachelor degree",
          "Degree: graduation year" => "2021",
        })
        described_class.call(csv_row: csv_row)
      end

      it "create's the trainee's non-uk degree" do
        degree = trainee.degrees.last
        expect(degree.locale_code).to eq("non_uk")
        expect(degree.uk_degree).to be_nil
        expect(degree.non_uk_degree).to eq("Bachelor degree")
        expect(degree.subject).to eq("Akkadian language")
        expect(degree.institution).to be_nil
        expect(degree.graduation_year).to eq(2021)
        expect(degree.grade).to be_nil
        expect(degree.other_grade).to be_nil
        expect(degree.country).to eq("Germany")
      end
    end

    context "when the trainee does not live in the UK" do
      before do
        csv_row.merge!({ "Outside UK address" => "Another land" })
        described_class.call(csv_row: csv_row)
      end

      it "sets the correct address fields" do
        expect(trainee.locale_code).to eq("non_uk")
        expect(trainee.address_line_one).to be_nil
        expect(trainee.town_city).to be_nil
        expect(trainee.postcode).to be_nil
        expect(trainee.international_address).to eq("Another land")
      end
    end

    describe "setting the trainee's diversity details" do
      context "when ethnicity is 'Not provided'" do
        it "sets the ethnic_group and background to 'Not provided'" do
          described_class.call(csv_row: csv_row)
          expect(trainee.ethnic_group).to eq(Diversities::ETHNIC_GROUP_ENUMS[:not_provided])
          expect(trainee.ethnic_background).to eq(Diversities::NOT_PROVIDED)
          expect(trainee.diversity_disclosure).to eq(Diversities::DIVERSITY_DISCLOSURE_ENUMS[:diversity_not_disclosed])
        end
      end

      context "when ethnicity is provided" do
        before do
          csv_row.merge!({ "Ethnicity" => "Black - Caribbean or Caribbean British" })
          described_class.call(csv_row: csv_row)
        end

        it "sets the ethnic_group and background" do
          expect(trainee.ethnic_group).to eq(Diversities::ETHNIC_GROUP_ENUMS[:black])
          expect(trainee.ethnic_background).to eq(Diversities::CARIBBEAN)
        end
      end

      context "when disability is provided" do
        before do
          csv_row.merge!({ "Disabilities" => "Learning difficulty" })
          described_class.call(csv_row: csv_row)
        end

        it "sets the disability and disability disclosure" do
          expect(trainee.disabilities.first.name).to eq("Learning difficulty")
          expect(trainee.diversity_disclosure).to eq(Diversities::DIVERSITY_DISCLOSURE_ENUMS[:diversity_disclosed])
          expect(trainee.disability_disclosure).to eq(Diversities::DISABILITY_DISCLOSURE_ENUMS[:disabled])
        end
      end

      context "when disability is provided as No known disability" do
        before do
          csv_row.merge!({ "Disabilities" => "No disabilities" })
          described_class.call(csv_row: csv_row)
        end

        it "sets no disabilities on the trainee and sets the disability disclosures correctly" do
          expect(trainee.diversity_disclosure).to eq(Diversities::DIVERSITY_DISCLOSURE_ENUMS[:diversity_disclosed])
          expect(trainee.disability_disclosure).to eq(Diversities::DISABILITY_DISCLOSURE_ENUMS[:no_disability])
          expect(trainee.disabilities).to be_empty
        end
      end

      context "when multiple disabilities are provided" do
        before do
          csv_row.merge!({ "Disabilities" => "Learning difficulty, Long-standing illness" })
          described_class.call(csv_row: csv_row)
        end

        it "sets the disabilities and disability disclosure" do
          expect(trainee.disabilities.map(&:name)).to include("Learning difficulty", "Long-standing illness")
          expect(trainee.diversity_disclosure).to eq(Diversities::DIVERSITY_DISCLOSURE_ENUMS[:diversity_disclosed])
          expect(trainee.disability_disclosure).to eq(Diversities::DISABILITY_DISCLOSURE_ENUMS[:disabled])
        end
      end
    end

    context "when the trainee's course is in the primary age range but subject isn't" do
      before do
        csv_row.merge!({ "Course age range" => "7 to 11" })
        described_class.call(csv_row: csv_row)
      end

      it "adds 'primary teaching' and places it in the course_subject_one column" do
        expect(trainee.course_subject_one).to eq(CourseSubjects::PRIMARY_TEACHING)
        expect(trainee.course_subject_two).to eq(CourseSubjects::BIOLOGY)
      end
    end

    context "when the trainee's course is in the primary age range but primary subject not the first subject" do
      before do
        csv_row.merge!({
          "Course age range" => "7 to 11",
          "Course ITT subject 2" => "primary teaching",
        })
        described_class.call(csv_row: csv_row)
      end

      it "moves 'primary teaching' to be the first subject" do
        expect(trainee.course_subject_one).to eq(CourseSubjects::PRIMARY_TEACHING)
        expect(trainee.course_subject_two).to eq(CourseSubjects::BIOLOGY)
      end
    end
  end
end