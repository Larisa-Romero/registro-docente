# frozen_string_literal: true

require "rails_helper"

describe "hpitt:import" do
  include SeedHelper

  before do
    generate_seed_nationalities
    generate_seed_disabilities
  end

  subject do
    args = Rake::TaskArguments.new([:csv_path], [csv_path])
    Rake::Task["hpitt:import"].execute(args)
  end

  let!(:school) { create(:school, urn: 123) }
  let!(:provider) { create(:provider, :teach_first) }

  context "with valid data" do
    let(:csv_path) {
      File.join(__dir__, "..", "..", "support", "fixtures", "hpitt_import.csv")
    }

    it "creates the trainee/degree" do
      expect { subject }.to change { Trainee.count }.from(0).to(1)

      expect(trainee.reload.trainee_id).to eq("A1")
      expect(trainee.first_names).to eq "Abz"
      expect(trainee.middle_names).to eq ""
      expect(trainee.last_name).to eq "McPhee"
      expect(trainee.date_of_birth).to eq Date.parse("5/2/1990")
      expect(trainee.email).to eq "test@example.com"
      expect(trainee.gender).to eq "female"

      expect(trainee.address_line_one).to eq "1 This Road"
      expect(trainee.address_line_two).to eq ""
      expect(trainee.town_city).to eq "London"
      expect(trainee.postcode).to eq "SW1A 1AA"

      expect(trainee.nationalities.count).to eq(1)
      expect(trainee.nationalities.first).to eq(Nationality.find_by_name("british"))
      expect(trainee.diversity_disclosure).to eq Diversities::DIVERSITY_DISCLOSURE_ENUMS[:diversity_disclosed]
      expect(trainee.ethnic_group).to eq(ETHNIC_GROUP_ENUMS[:asian])
      expect(trainee.ethnic_background).to eq(Diversities::INDIAN)
      expect(trainee.disability_disclosure).to eq Diversities::DISABILITY_DISCLOSURE_ENUMS[:not_provided]
      expect(trainee.disabilities.count).to eq(0)
      expect(trainee.region).to eq("South West")

      expect(trainee.itt_start_date).to eq Date.parse("9/9/2022")
      expect(trainee.itt_end_date).to eq Date.parse("31/7/2023")
      expect(trainee.trainee_start_date).to eq Date.parse("9/9/2022")
      expect(trainee.course_subject_one).to eq "history"
      expect(trainee.study_mode).to eq "full_time"
      expect(trainee.course_education_phase).to eq "secondary"

      expect(trainee.training_route).to eq "hpitt_postgrad"
      expect(trainee.training_initiative).to eq "no_initiative"
      expect(trainee.trainee_id).to eq "A1"

      expect(trainee.progress.attributes.values).to all be(true)

      expect(trainee.degrees.count).to eq 1
      degree = trainee.degrees.first
      expect(degree.locale_code).to eq "non_uk"
      expect(degree.non_uk_degree).to eq "Bachelor degree"
      expect(degree.subject).to eq "English studies"
      expect(degree.country).to eq "Germany"
    end
  end

  context "with invalid data" do
    # This csv has two rows, the second row has an invalid degree subject for a school that
    # doesn't exist
    let(:csv_path) {
      File.join(__dir__, "..", "..", "support", "fixtures", "hpitt_import_invalid.csv")
    }

    it "gives an error including which row had the problem, and still creates the valid trainee" do
      expect(Sentry).to receive(:capture_exception).with(StandardError)
      expect { subject }.to change { Trainee.count }.from(0).to(1)
    end
  end
end
