# frozen_string_literal: true

require "rails_helper"

module Trainees
  describe CreateTimelineEvents do
    let(:system_admin) { create(:user, :system_admin) }
    let(:provider_user) { create(:user) }
    let(:trainee) { create(:trainee) }

    subject { described_class.call(audit: trainee.own_and_associated_audits.first) }

    describe "#call" do
      context "with a trainee creation audit" do
        it "returns a trainee created event" do
          expect(subject.title).to eq(t("components.timeline.titles.trainee.create"))
        end
      end

      context "with a trainee update audit" do
        before do
          trainee.update!(first_names: "name")
        end

        context "made by a provider user" do
          before do
            trainee.own_and_associated_audits.first.update(user: provider_user)
          end

          it "returns a timeline event that reflects the update" do
            expect(subject.first.title).to eq("First names updated")
          end

          it "returns a timeline event with the user's name" do
            expect(subject.first.username).to eq(provider_user.name)
          end
        end

        context "made by a system admin" do
          before do
            trainee.own_and_associated_audits.first.update(user: system_admin)
          end

          it "returns a timeline event that reflects the update" do
            expect(subject.first.title).to eq("First names updated")
          end

          it "returns a timeline event obscuring the admin's name" do
            expect(subject.first.username).to eq("DfE administrator")
          end
        end
      end

      context "with a trainee state change audit" do
        before do
          trainee.submit_for_trn!
        end

        it "returns a 'state change' timeline event" do
          expect(subject.title).to eq(t("components.timeline.titles.trainee.submitted_for_trn"))
        end
      end

      context "with an associated audit" do
        let(:degree) { create(:degree, trainee: trainee) }

        it "returns a 'creation' timeline event" do
          degree.reload
          expect(subject.title).to eq(t("components.timeline.titles.degree.create"))
        end
      end

      context "with a destroy associated audit" do
        let(:degree) { create(:degree, trainee: trainee) }

        before do
          degree.reload
          trainee.degrees.first.destroy!
        end

        it "returns a 'destroyed' timeline event" do
          expect(subject.title).to eq(t("components.timeline.titles.degree.destroy"))
        end
      end
    end
  end
end
