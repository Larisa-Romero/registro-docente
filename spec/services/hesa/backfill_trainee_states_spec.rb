# frozen_string_literal: true

require "rails_helper"

module Hesa
  describe BackfillTraineeStates do
    let(:trainee) { create(:trainee, :trn_received, :imported_from_hesa) }
    let(:end_date) { Time.zone.today }
    let(:reason_for_leaving_code) { %w[11 05 03].sample }
    let(:reason_for_leaving) { Hesa::CodeSets::ReasonsForLeavingCourse::MAPPING[reason_for_leaving_code] }

    subject { described_class.call(trainee:) }

    context "when HESA student is withdrawn" do
      before do
        trainee.hesa_student.update_columns(reason_for_leaving: reason_for_leaving_code, end_date: end_date)
        subject
      end

      it "updates trainee state" do
        expect(trainee.state).to eq("withdrawn")
      end

      it "updates withdraw_reason" do
        expect(trainee.withdraw_reason).to eq(reason_for_leaving)
      end

      it "updates withdraw_data" do
        expect(trainee.withdraw_date).to eq(end_date)
      end
    end

    context "when HESA student is not withdrawn" do
      before do
        subject
      end

      it "does not change the state" do
        expect(trainee.state).to eq("trn_received")
      end

      it "does not change withdraw_reason" do
        expect(trainee.withdraw_reason).to be_nil
      end

      it "does not change withdraw_data" do
        expect(trainee.withdraw_date).to be_nil
      end
    end

    context "when there is no hesa_student for the trainee" do
      let(:trainee) { create(:trainee, :trn_received) }

      it "does not raise an error" do
        expect { subject }.not_to raise_error
      end

      it "does not change the trainee" do
        expect { subject }.not_to change { trainee.state }
      end
    end
  end
end
