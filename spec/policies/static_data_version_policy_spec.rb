# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticDataVersionPolicy, type: :policy do
  subject(:policy) { described_class.new(user.default_identity) }

  context 'as an administrator' do
    let(:user) { create(:admin_user) }

    it { is_expected.to permit_actions(:index, :show, :check, :download, :import) }
  end

  context 'as a regular user' do
    let(:user) { create(:registered_user) }

    it { is_expected.to forbid_actions(:index, :show, :check, :download, :import) }
  end
end
