# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Settings::AccountController, type: :request do
  before { sign_in(user) }

  describe 'DELETE #destroy' do
    context 'when user is the only admin' do
      let(:user) { create(:admin_user) }

      before { delete settings_account_path }

      it 'redirects to the account settings page' do
        expect(response).to redirect_to(settings_account_path)
      end

      it 'it does not destroy the user' do
        expect(user.reload).to be_persisted
      end
    end
  end
end
