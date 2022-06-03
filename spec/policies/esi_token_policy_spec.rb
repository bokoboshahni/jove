# frozen_string_literal: true

require 'policy_helper'

RSpec.describe ESITokenPolicy, type: :policy do
  include_context 'Policy users'

  let(:user_token) { create(:esi_token, identity: user_identity) }

  let(:other_user) { create(:registered_user) }
  let(:other_identity) { other_user.default_identity }
  let(:other_token) { create(:esi_token, identity: other_identity) }

  it { is_expected.to permit_actions(:index, :new, :create) }

  context "as a regular user with one of the user's own tokens" do
    subject(:policy) { described_class.new(user_identity, user_token) }

    it { is_expected.to permit_actions(%i[confirm_approve approve confirm_reject reject confirm_destroy destroy]) }
  end

  context "as a regular user with another user's token" do
    subject(:policy) { described_class.new(user_identity, other_token) }

    it { is_expected.to forbid_actions(%i[confirm_approve approve confirm_reject reject confirm_destroy destroy]) }
  end

  context "as an administrator with a user's token" do
    subject(:policy) { described_class.new(admin_identity, user_token) }

    it { is_expected.to permit_actions(%i[confirm_destroy destroy]) }

    it { is_expected.to forbid_actions(%i[confirm_approve approve confirm_reject reject]) }
  end

  describe ESITokenPolicy::Scope do
    subject(:scope) { described_class }

    it 'passes the scope through for admins' do
      users = create_list(:registered_user, 5)
      identities = users.map(&:default_identity)
      tokens = identities.map { |i| create(:esi_token, identity: i) }

      expect(scope.new(admin_identity, ESIToken.order(:id)).resolve).to include(*tokens)
    end

    it "includes the user's own tokens for regular users" do
      identities = create_list(:identity, 2, user:)
      tokens = identities.map { |i| create(:esi_token, identity: i) }

      expect(scope.new(user_identity, ESIToken.order(:id)).resolve).to include(*tokens)
    end

    it "does not include other users' tokens for regular users" do
      expect(scope.new(user_identity, ESIToken.order(:id)).resolve).not_to include(other_token)
    end
  end
end
