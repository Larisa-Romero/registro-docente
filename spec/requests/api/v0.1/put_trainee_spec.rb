# frozen_string_literal: true

require "rails_helper"

describe "Trainees API" do
  describe "PUT /api/v0.1/trainees/:id" do
    let(:trainee) { create(:trainee, first_names: "Bob") }
    let(:other_trainee) { create(:trainee, first_names: "Bob") }
    let(:provider) { trainee.provider }

    context "with a valid authentication token and the feature flag on" do
      let(:token) { AuthenticationToken.create_with_random_token(provider:) }

      it "returns status 404 if the trainee does not exist" do
        put(
          "/api/v0.1/trainees/missing-trainee-slug",
          headers: { Authorization: "Bearer #{token}" },
          params: { data: { first_names: "Alice" } },
        )
        expect(response).to have_http_status(:not_found)
      end

      it "returns status 422 if the request body is invalid (if not a serialised trainee)" do
        put(
          "/api/v0.1/trainees/#{trainee.slug}",
          headers: { Authorization: "Bearer #{token}" },
          params: { foo: { bar: "Alice" } },
        )
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns 404 if the trainee does not belong to the authenticated provider" do
        put(
          "/api/v0.1/trainees/#{other_trainee.slug}",
          headers: { Authorization: "Bearer #{token}" },
          params: { data: { first_names: "Alice" } },
        )
        expect(response).to have_http_status(:not_found)
      end

      it "returns status 200 with a valid JSON response" do
        put(
          "/api/v0.1/trainees/#{trainee.slug}",
          headers: { Authorization: "Bearer #{token}" },
          params: { data: { first_names: "Alice" } },
        )
        expect(response).to have_http_status(:ok)
        expect(trainee.reload.first_names).to eq("Alice")
      end
    end
  end
end
