# frozen_string_literal: true

require "rails_helper"

module Diversities
  describe EthnicGroupForm, type: :model do
    let(:params) { {} }
    let(:trainee) do
      create(
        :trainee,
        :diversity_disclosed,
        ethnic_group: Diversities::ETHNIC_GROUP_ENUMS[:other],
        ethnic_background: Diversities::ANOTHER_ETHNIC_BACKGROUND,
        additional_ethnic_background: "Crab people",
      )
    end
    let(:form_store) { class_double(FormStore) }

    subject { described_class.new(trainee, params: params, store: form_store) }

    before do
      allow(form_store).to receive(:get).and_return(nil)
    end

    describe "validations" do
      it { is_expected.to validate_presence_of(:ethnic_group) }
      it { is_expected.to validate_inclusion_of(:ethnic_group).in_array(Diversities::ETHNIC_GROUP_ENUMS.values) }
    end

    describe "#stash" do
      it "uses FormStore to temporarily save the fields under a key combination of trainee ID and ethnic_group" do
        expect(form_store).to receive(:set).with(trainee.id, :ethnic_group, subject.fields)

        subject.stash
      end
    end

    describe "#save!" do
      let(:ethnic_group) { Diversities::ETHNIC_GROUP_ENUMS[:not_provided] }

      before do
        allow(form_store).to receive(:get).and_return({ "ethnic_group" => ethnic_group })
        allow(form_store).to receive(:set).with(trainee.id, :ethnic_group, nil)
      end

      it "takes any data from the form store and saves it to the database" do
        expect { subject.save! }.to change(trainee, :ethnic_group).to(ethnic_group)
      end

      context "ethnic_group is set to not provided" do
        let(:ethnic_background) { Diversities::ETHNIC_GROUP_ENUMS[:not_provided] }

        before do
          allow(form_store).to receive(:get).and_return(
            {
              "ethnic_group" => ethnic_group,
              "ethnic_background" => Diversities::ANOTHER_ETHNIC_BACKGROUND,
            },
          )
        end

        it "clears any ethnic background info" do
          expect { subject.save! }.to change(trainee, :ethnic_background).to(nil)
            .and change(trainee, :additional_ethnic_background).to(nil)
        end
      end
    end
  end
end
