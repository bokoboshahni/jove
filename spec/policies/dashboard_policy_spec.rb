# frozen_string_literal: true

require 'policy_helper'

RSpec.describe DashboardPolicy, type: :policy do
  include_context 'Policy users'

  subject(:policy) { described_class }

  permissions :show? do
    it 'grants access' do
      expect(policy).to permit(user)
    end
  end
end
