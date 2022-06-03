# frozen_string_literal: true

require 'policy_helper'

RSpec.describe AutocompletePolicy, type: :policy do
  include_context 'Policy users'

  context 'as an admin user' do
    subject(:policy) { described_class.new(admin_identity) }

    it { is_expected.to permit_action(:index) }
  end

  context 'as a non-admin user' do
    subject(:policy) { described_class.new(user_identity) }

    it { is_expected.to forbid_action(:index) }
  end
end
