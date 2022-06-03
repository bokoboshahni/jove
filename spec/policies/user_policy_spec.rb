# frozen_string_literal: true

require 'policy_helper'

RSpec.describe UserPolicy, type: :policy do
  include_context 'Policy users'

  context 'as an admin user' do
    subject(:policy) { described_class.new(admin_identity) }

    it { is_expected.to permit_action(:index) }
  end

  context 'as a non-admin user' do
    subject(:policy) { described_class.new(user_identity) }

    it { is_expected.to forbid_action(:index) }
  end

  context 'as an admin user with a user' do
    subject(:policy) { described_class.new(admin_identity, user) }

    it { is_expected.to permit_actions(:show, :update, :destroy) }
  end

  context 'as a non-admin user with themself' do
    subject(:policy) { described_class.new(user_identity, user) }

    it { is_expected.to permit_actions(:show, :update, :destroy) }
  end

  context 'as a non-admin user with another user' do
    subject(:policy) { described_class.new(user_identity, admin) }

    it { is_expected.to forbid_actions(:show, :update, :destroy) }
  end

  describe '.scope' do
    it 'passes the scope through for admins' do
      users = create_list(:registered_user, 5)
      scope = described_class::Scope.new(admin_identity, User.order(:id)).resolve
      expect(scope).to include(*users)
    end

    it 'nullifies the scope for non-admins' do
      create_list(:registered_user, 5)
      scope = described_class::Scope.new(user_identity, User.order(:id)).resolve
      expect(scope).to be_empty
    end
  end
end
