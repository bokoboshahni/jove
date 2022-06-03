# frozen_string_literal: true

RSpec.shared_context 'Policy users', type: :policy do
  let(:user) { create(:registered_user) }
  let(:user_identity) { user.default_identity }
  let(:admin) { create(:admin_user) }
  let(:admin_identity) { admin.default_identity }
end
