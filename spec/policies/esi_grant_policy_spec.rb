# frozen_string_literal: true

require 'policy_helper'

RSpec.describe ESIGrantPolicy, type: :policy do
  include_context 'Policy users'

  it { is_expected.to permit_actions(:index) }

  context 'as an administrator' do
    subject(:policy) { described_class.new(admin_identity) }

    it { is_expected.to permit_actions(:new, :create) }
  end

  context 'as an administrator with a grant' do
    let(:grant) { create(:structure_discovery_grant) }

    subject(:policy) { described_class.new(admin_identity, grant) }

    it { is_expected.to permit_actions(:confirm_destroy, :destroy) }

    it { is_expected.to forbid_actions(:confirm_approve, :approve, :confirm_reject, :reject) }
  end

  context 'as a regular user' do
    subject(:policy) { described_class.new(user_identity) }

    it { is_expected.to forbid_actions(:new, :create) }
  end

  context 'as a regular user with a grant' do
    let(:grant) { create(:structure_discovery_grant, identity: user_identity) }

    subject(:policy) { described_class.new(user_identity, grant) }

    it {
      is_expected.to permit_actions(:confirm_approve, :approve, :confirm_reject, :reject, :confirm_destroy, :destroy)
    }
  end

  context "as a regular user with another user's grant" do
    let(:grant) { create(:structure_discovery_grant) }

    subject(:policy) { described_class.new(user_identity, grant) }

    it {
      is_expected.to forbid_actions(:confirm_approve, :approve, :confirm_reject, :reject, :confirm_destroy, :destroy)
    }
  end

  describe ESIGrantPolicy::Scope do
    subject(:scope) { described_class }

    it 'passes the scope through for admins' do
      grants = create_list(:structure_discovery_grant, 2)

      expect(scope.new(admin_identity, ESIGrant.order(:id)).resolve).to include(*grants)
    end

    it "only includes the user's own grants for regular users" do
      create_list(:structure_discovery_grant, 2)
      token = create(:esi_token, identity: user_identity)

      expect(scope.new(user_identity, ESIGrant.order(:id)).resolve).to eq(token.grants)
    end
  end
end
