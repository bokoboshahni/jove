# frozen_string_literal: true

require 'policy_helper'

RSpec.describe StaticDataVersionPolicy, type: :policy do
  include_context 'Policy users'

  subject(:policy) { described_class.new(user_identity) }

  context 'as an administrator' do
    let(:user) { create(:admin_user) }

    it { is_expected.to permit_actions(:index, :show, :check, :download, :import) }
  end

  context 'as a regular user' do
    let(:user) { create(:registered_user) }

    it { is_expected.to forbid_actions(:index, :show, :check, :download, :import) }
  end
end
