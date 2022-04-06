# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Account settings', type: :system do
  let(:user) { create(:registered_user) }

  before do
    sign_in(user)
  end

  describe 'deleting account', js: true do
    it 'deletes the account' do
      visit settings_account_path

      click_on 'Delete your account'

      expect(page).to have_text('Delete account?')

      click_on 'Delete'

      expect(page).to have_text('Your account has been deleted.')
      expect(page).to have_current_path('/')
    end
  end
end
