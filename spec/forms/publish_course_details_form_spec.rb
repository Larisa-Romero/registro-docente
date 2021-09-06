# frozen_string_literal: true

require "rails_helper"

describe PublishCourseDetailsForm, type: :model do
  let(:params) { {} }
  let(:trainee) { build(:trainee) }
  let(:form_store) { class_double(FormStore) }

  subject { described_class.new(trainee, params: params, store: form_store) }

  before do
    allow(form_store).to receive(:get).and_return(nil)
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:course_code) }
  end

  context "valid course_code" do
    let(:params) { { course_code: "c0de" } }
    let(:trainee) { create(:trainee) }

    describe "#stash" do
      it "uses FormStore to temporarily save the fields under a key combination of trainee ID and course_details" do
        expect(form_store).to receive(:set).with(trainee.id, :publish_course_details, params)

        subject.stash
      end
    end
  end

  context "missing course_code" do
    describe "#stash" do
      it "returns false and adds an error to the form" do
        expect(subject.stash).to eq false
        expect(subject.errors.messages).to eq({ course_code: ["Select a course"] })
      end
    end
  end

  describe "manual entry chosen?" do
    context "when course_code is NOT_LISTED" do
      it { be_true }
    end

    context "when course_code is nil" do
      let(:params) { { course_code: "not_listed" } }

      it { be_false }
    end

    context "when course_code is something else" do
      let(:params) { { course_code: "c0de" } }

      it { be_false }
    end
  end
end
