# frozen_string_literal: true

RSpec.shared_context 'Administration scenarios', type: :system do
  let(:admin) { create(:admin_user) }

  before { sign_in(admin) }
end

RSpec.shared_context 'User scenarios', type: :system do
  let(:user) { create(:registered_user) }

  before { sign_in(user) }
end

RSpec.shared_context 'Market scenarios', type: :system do
  before { Flipper.enable :markets }
end
