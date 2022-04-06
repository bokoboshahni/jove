# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :request do
  describe 'GET /' do
    context 'when logged out' do
      it 'responds with success' do
        get root_path

        expect(response).to have_http_status(200)
      end
    end

    context 'when logged in' do
      it 'redirects to the dashboard' do
        user = create(:user)
        sign_in(user)
        get root_path

        expect(response).to redirect_to(dashboard_root_path)
      end
    end
  end
end
