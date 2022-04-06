# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DashboardPolicy, type: :policy do
  let(:user) { create(:user) }

  subject(:policy) { described_class }

  permissions :show? do
    it 'grants access' do
      expect(policy).to permit(user)
    end
  end
end
