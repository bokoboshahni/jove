# frozen_string_literal: true

require 'policy_helper'

RSpec.describe IdentityPolicy, type: :policy do
  include_context 'Policy users'

  it { is_expected.to permit_actions(:index, :create) }

  context "as a regular user with one of the user's own identities" do
    subject(:policy) { described_class.new(user_identity, user_identity) }

    it { is_expected.to permit_actions(%i[show update confirm_destroy destroy change_default switch]) }
  end

  context "as a regular user with another user's identity" do
    let(:other_user) { create(:registered_user) }

    subject(:policy) { described_class.new(user_identity, other_user.default_identity) }

    it { is_expected.to forbid_actions(%i[show update confirm_destroy destroy change_default switch]) }
  end

  context "as an administrator with a user's identity" do
    subject(:policy) { described_class.new(admin_identity, user_identity) }

    it { is_expected.to permit_actions(%i[show update confirm_destroy destroy]) }
  end

  describe IdentityPolicy::Scope do
    subject(:scope) { described_class }

    it 'passes the scope through for admins' do
      users = create_list(:registered_user, 5)
      identities = users.map(&:default_identity)

      expect(scope.new(admin_identity, Identity.order(:id)).resolve).to include(*identities)
    end

    it "only includes the user's own identities for regular users" do
      create_list(:registered_user, 5)

      expect(scope.new(user_identity, Identity.order(:id)).resolve).to eq([user_identity])
    end
  end
end
