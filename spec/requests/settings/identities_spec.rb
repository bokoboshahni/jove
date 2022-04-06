# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Settings::IdentitiesController, type: :request do
  let(:user) { create(:registered_user) }

  before { sign_in(user) }

  describe 'POST #create' do
    before { post settings_identities_path }

    it 'redirects to the EVE SSO server' do
      expect(response).to redirect_to(%r{https://login\.eveonline\.com/v2/oauth/authorize})
    end
  end

  describe 'DELETE #destroy' do
    context "with the user's default identity" do
      before { delete settings_identity_path(user.default_identity) }

      it 'redirects to the identities index' do
        expect(response).to redirect_to(settings_identities_path)
      end

      it 'does not destroy the identity' do
        expect(user.default_identity).to be_persisted
      end
    end
  end
end
