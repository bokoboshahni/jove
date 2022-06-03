# frozen_string_literal: true

require 'policy_helper'

RSpec.describe ApplicationPolicy, type: :policy do
  include_context 'Policy users'

  subject(:policy) { described_class }

  permissions :index?, :show?, :create?, :new?, :update?, :edit?, :destroy? do
    it 'denies access by default' do
      expect(policy).not_to permit(user_identity)
    end

    it 'grants access to admins' do
      expect(policy).to permit(admin_identity)
    end
  end

  describe ApplicationPolicy::Scope do
    describe '#resolve' do
      context 'with a non-admin user' do
        it 'returns nothing' do
          expect(described_class.new(user_identity, User.order(:id)).resolve).to be_empty
        end
      end

      context 'with an admin user' do
        it 'passes the scope through' do
          expect(described_class.new(admin_identity, User.order(:id)).resolve).to include(admin)
        end
      end
    end
  end
end
