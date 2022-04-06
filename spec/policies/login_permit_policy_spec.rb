# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoginPermitPolicy, type: :policy do
  subject(:policy) { described_class.new(user_identity) }

  let(:user_identity) { user.default_identity }

  context 'as an admin user' do
    let(:user) { create(:admin_user) }

    it { is_expected.to permit_actions(:index, :create, :destroy) }

    it 'passes the scope through' do
      permits = create_list(:login_permit, 5)
      scope = described_class::Scope.new(user_identity, LoginPermit.order(:id)).resolve
      expect(scope).to include(*permits)
    end
  end

  context 'as a non-admin user' do
    let(:user) { create(:registered_user) }

    it { is_expected.to forbid_actions(:index, :create, :destroy) }

    it 'nullifies the scope' do
      permits = create_list(:login_permit, 5)
      scope = described_class::Scope.new(user_identity, LoginPermit.order(:id)).resolve
      expect(scope).not_to include(*permits)
    end
  end
end
