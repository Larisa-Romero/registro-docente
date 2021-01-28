# frozen_string_literal: true

require "rails_helper"

module Dttp
  describe RegisterForTrn do
    include ActiveJob::TestHelper

    describe "#call" do
      let(:trainee) { create(:trainee, :with_programme_details) }
      let(:degree) { build(:degree, :uk_degree_with_details) }

      let(:batch_request) { instance_double(BatchRequest) }
      let(:trainee_creator_dttp_id) { SecureRandom.uuid }

      let(:contact_change_set_id) { SecureRandom.uuid }
      let(:placement_assignment_change_set_id) { SecureRandom.uuid }
      let(:degree_qualification_change_set_id) { SecureRandom.uuid }

      let(:contact_entity_id) { SecureRandom.uuid }
      let(:placement_assignment_entity_id) { SecureRandom.uuid }
      let(:degree_qualification_entity_id) { SecureRandom.uuid }

      let(:contact_payload) { Params::Contact.new(trainee, trainee_creator_dttp_id).to_json }
      let(:placement_assignment_payload) { Params::PlacementAssignment.new(trainee, contact_change_set_id).to_json }
      let(:degree_qualification_payload) do
        Params::DegreeQualification.new(degree, contact_change_set_id, placement_assignment_change_set_id).to_json
      end

      let(:dttp_response) do
        <<~DTTP_RESPONSE
          Content-ID: #{contact_change_set_id}
          OData-EntityId: /contacts(#{contact_entity_id})
          Content-ID: #{placement_assignment_change_set_id}
          OData-EntityId: /dfe_placementassignments(#{placement_assignment_entity_id})
          Content-ID: #{degree_qualification_change_set_id}
          OData-EntityId: /dfe_degreequalifications(#{degree_qualification_entity_id})
        DTTP_RESPONSE
      end

      before do
        allow(AccessToken).to receive(:fetch).and_return("token")
        allow(BatchRequest).to receive(:new).and_return(batch_request)
        trainee.degrees << degree
      end

      it "submits a batch request to create contact, placement assignment and degree qualification entities and updates trainee record" do
        expect(batch_request).to receive(:add_change_set).with(
          entity: "contacts",
          payload: contact_payload,
        ).and_return(
          contact_change_set_id,
        )

        expect(batch_request).to receive(:add_change_set).with(
          entity: "dfe_placementassignments",
          payload: placement_assignment_payload,
        ).and_return(
          placement_assignment_change_set_id,
        )

        expect(batch_request).to receive(:add_change_set).with(
          entity: "dfe_degreequalifications",
          payload: degree_qualification_payload,
        ).and_return(
          degree_qualification_change_set_id,
        )

        expect(batch_request).to receive(:submit).and_return(dttp_response)

        expect {
          described_class.call(trainee: trainee, trainee_creator_dttp_id: trainee_creator_dttp_id)
        }.to change(trainee, :dttp_id).to(
          contact_entity_id,
        ).and change(trainee, :placement_assignment_dttp_id).to(
          placement_assignment_entity_id,
        ).and have_enqueued_job(ChangeTraineeStatusJob).with(
          status: DttpStatuses::PROSPECTIVE_TRAINEE_TRN_REQUESTED,
          entity_id: contact_entity_id,
          entity_type: :contact,
        )
      end
    end
  end
end
