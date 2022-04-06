# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :request do
  let(:user) { create(:admin_user) }

  before { sign_in(user) }

  describe 'DELETE #destroy' do
    context 'with the current user' do
      before { delete admin_user_path(user) }

      it 'redirects to the users index' do
        expect(response).to redirect_to(admin_users_path)
      end

      it 'does not destroy the user' do
        expect(user.reload).to be_persisted
      end
    end
  end
end
