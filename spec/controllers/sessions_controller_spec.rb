# frozen_string_literal: true

require "rails_helper"

describe SessionsController, type: :controller do
  include DfESignInUserHelper
  let(:user) { create(:user) }
  let(:request_callback) do
    request.env["omniauth.auth"] = user_exists_in_dfe_sign_in(user: user)
    post :callback
  end

  describe "#callback" do
    context "existing database user" do
      it "creates a session for the signed in user" do
        request_callback
        expect(session[:dfe_sign_in_user]["dfe_sign_in_uid"]).to eq(user.dfe_sign_in_uid)
        expect(session[:dfe_sign_in_user]["email"]).to eq(user.email)

        expect(session[:dfe_sign_in_user]["first_name"]).to eq(user.first_name)
        expect(session[:dfe_sign_in_user]["last_name"]).to eq(user.last_name)
      end

      it "redirects to the trainees index page if no original path stored in the session" do
        request_callback
        expect(response).to redirect_to(root_path)
      end

      it "redirects to the original requested page if it exists in the session" do
        session[:requested_path] = "/trainees/qts_awarded"
        request_callback
        expect(response).to redirect_to("/trainees/qts_awarded")
      end

      it "clears the redirect_back_to key of the session after a redirect" do
        session[:requested_path] = "/trainees/qts_awarded"
        request_callback
        expect(session[:requested_path]).to be_nil
      end
    end

    context "non existing database user" do
      let(:user) { build(:user) }
      it "do not creates a session for the user" do
        request_callback
        expect(session[:dfe_sign_in_user]).to be_nil
      end

      it "redirects to the sign in user not found page" do
        request_callback
        expect(response).to redirect_to(sign_in_user_not_found_path)
      end

      describe "save the new user", "feature_allow_user_creation": true do
        it "creates a session for the new user" do
          request_callback
          expect(session[:dfe_sign_in_user]["dfe_sign_in_uid"]).to eq(user.dfe_sign_in_uid)
          expect(session[:dfe_sign_in_user]["email"]).to eq(user.email)

          expect(session[:dfe_sign_in_user]["first_name"]).to eq(user.first_name)
          expect(session[:dfe_sign_in_user]["last_name"]).to eq(user.last_name)
        end

        it "redirects to the trainees index page" do
          request_callback
          expect(response).to redirect_to(root_path)
        end

        it "saved non existing user to database" do
          expect { request_callback }.to change { User.count }
          .from(0).to(1)
        end

        it "created provider if needed" do
          expect { request_callback }.to change { Provider.count }
          .from(0).to(1)

          expect { request_callback }.to_not change { Provider.count }
          .from(1)
        end
      end
    end
  end
end
