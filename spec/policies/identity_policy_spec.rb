# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IdentityPolicy, type: :policy do
  let(:user) { create(:registered_user) }
  let(:user_identity) { user.default_identity }

  it { is_expected.to permit_actions(:index, :create) }

  context "as a regular user with one of the user's own identities" do
    subject(:policy) { described_class.new(user_identity, user.default_identity) }

    it { is_expected.to permit_actions(%i[show update confirm_destroy destroy change_default switch]) }
  end

  context "as a regular user with another user's identity" do
    let(:other_user) { create(:registered_user) }

    subject(:policy) { described_class.new(user_identity, other_user.default_identity) }

    it { is_expected.to forbid_actions(%i[show update confirm_destroy destroy change_default switch]) }
  end

  context "as an administrator with a user's identity" do
    let(:admin) { create(:registered_user, admin: true) }

    subject(:policy) { described_class.new(admin.default_identity, user.default_identity) }

    it { is_expected.to permit_actions(%i[show update confirm_destroy destroy]) }
  end

  describe IdentityPolicy::Scope do
    subject(:scope) { described_class }

    it 'passes the scope through for admins' do
      users = create_list(:registered_user, 5)
      identities = users.map(&:default_identity)
      admin = create(:registered_user, admin: true)

      expect(scope.new(admin.default_identity, Identity.order(:id)).resolve).to include(*identities)
    end

    it "only includes the user's own identities for regular users" do
      users = create_list(:registered_user, 5)
      user = users.first
      identity = user.default_identity

      expect(scope.new(identity, Identity.order(:id)).resolve).to eq([identity])
    end
  end
end
