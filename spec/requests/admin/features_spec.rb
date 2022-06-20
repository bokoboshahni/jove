# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::FeaturesController, type: :request do
  let(:user) { create(:admin_user) }

  before { sign_in(user) }

  describe 'GET #index' do
    before { get(admin_features_path) }

    it 'responds with success' do
      expect(response).to be_successful
    end
  end
end
