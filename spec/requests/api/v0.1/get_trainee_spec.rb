# frozen_string_literal: true

require "rails_helper"

describe "`GET /api/v0.1/trainees/:id` endpoint" do
  let(:token) { "trainee_token" }
  let!(:auth_token) { create(:authentication_token, hashed_token: AuthenticationToken.hash_token(token)) }
  let!(:trainee) { create(:trainee, slug: "12345", provider: auth_token.provider) }

  it_behaves_like "a register API endpoint", "/api/v0.1/trainees/12345", "trainee_token"

  context "when the trainee exists", feature_register_api: true do
    before do
      get(
        "/api/v0.1/trainees/#{trainee.slug}",
        headers: { Authorization: "Bearer #{token}" },
      )
    end

    it "returns the trainee" do
      parsed_trainee = JSON.parse(TraineeSerializer.new(trainee).as_hash.to_json)
      expect(response.parsed_body).to eq(parsed_trainee)
    end

    it "returns status code 200" do
      expect(response).to have_http_status(:ok)
    end
  end

  context "when the trainee does not exist", feature_register_api: true do
    before do
      get(
        "/api/v0.1/trainees/nonexistent",
        headers: { Authorization: "Bearer #{token}" },
      )
    end

    it "returns status code 404" do
      expect(response).to have_http_status(:not_found)
    end

    it "returns a not found message" do
      expect(response.parsed_body[:errors]).to contain_exactly({ error: "NotFound", message: "Trainee(s) not found" })
    end
  end
end
