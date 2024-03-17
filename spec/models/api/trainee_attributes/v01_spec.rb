# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::TraineeAttributes::V01 do
  subject { described_class.new }

  describe "validations" do
    Api::TraineeAttributes::V01::REQUIRED_ATTRIBUTES.each do |attribute|
      it "validates presence of #{attribute}" do
        subject.valid?
        expect(subject.errors.details[attribute]).to include(error: :blank)
      end
    end

    it "validates length of first_names" do
      subject.first_names = "a" * 51
      subject.valid?
      expect(subject.errors.details[:first_names]).to include(error: :too_long, count: 50)
    end

    it "validates length of last_name" do
      subject.last_name = "a" * 51
      subject.valid?
      expect(subject.errors.details[:last_name]).to include(error: :too_long, count: 50)
    end

    it "validates length of middle_names" do
      subject.middle_names = "a" * 51
      subject.valid?
      expect(subject.errors.details[:middle_names]).to include(error: :too_long, count: 50)
    end

    it "validates date_of_birth given as a string" do
      subject.date_of_birth = (Time.zone.today + 1.day).to_s
      subject.valid?
      expect(subject.errors.details[:date_of_birth]).to include(error: :future)
    end

    it "validates date_of_birth given as a date" do
      subject.date_of_birth = Time.zone.today + 1.day
      subject.valid?
      expect(subject.errors.details[:date_of_birth]).to include(error: :future)
    end

    it "validates inclusion of sex in Trainee.sexes.keys" do
      invalid_sex = "invalid"
      subject.sex = invalid_sex
      subject.valid?
      expect(subject.errors.details[:sex]).to include(error: :inclusion, value: invalid_sex)
    end

    it "derives course_allocation_subject from course_subject_one_name before validation" do
      subject.course_subject_one = "biology"
      create(:subject_specialism, name: subject.course_subject_one)
      subject.valid?
      expect(subject.course_allocation_subject).to be_present
    end
  end

  describe ".from_trainee" do
    let(:trainee) { create(:trainee, :with_hesa_trainee_detail, :completed) }

    subject(:attributes) { described_class.from_trainee(trainee) }

    it "pulls HesaTraineeDetail attributes from association" do
      expect(attributes.hesa_trainee_detail_attributes).to be_present

      Api::HesaTraineeDetailAttributes::V01::ATTRIBUTES.each do |attr|
        expect(attributes.hesa_trainee_detail_attributes.send(attr)).to be_present
      end
    end
  end

  describe "#deep_attributes" do
    let(:params) do
      {
        first_names: "Orval",
        last_name: "Erdman",
        email: "Orval.Erdman@example.com",
        middle_names: "Strosin",
        training_route: "assessment_only",
        sex: "prefer_not_to_say",
        diversity_disclosure: "diversity_not_disclosed",
        ethnic_group: nil,
        ethnic_background: nil,
        disability_disclosure: nil,
        course_subject_one: "mathematics",
        trn: nil,
        course_subject_two: nil,
        course_subject_three: nil,
        study_mode: "full_time",
        application_choice_id: nil,
        previous_last_name: "Mueller",
        itt_aim: "201",
        course_study_mode: "01",
        course_year: 2024,
        course_age_range: "13918",
        postgrad_apprenticeship_start_date: 2.months.from_now.iso8601,
        funding_method: "13919",
        ni_number: "QQ 12 34 56 C",
      }
    end

    subject(:attributes) { described_class.new(params) }

    it "wraps all hesa trainee detail attributes" do
      deep_attributes = attributes.deep_attributes.with_indifferent_access

      expect(deep_attributes).to have_key(:hesa_trainee_detail_attributes)
    end
  end
end
