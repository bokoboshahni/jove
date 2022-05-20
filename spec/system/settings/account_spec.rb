# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Account settings', type: :system do
  include_context 'User scenarios'

  scenario 'deleting own account' do
    visit(settings_account_path)

    click_on('Delete your account')

    expect(page).to have_text('Delete account?')

    click_on('Delete')
    wait_for_page_reload

    expect(page).to have_text('Your account has been deleted.')
    expect(page).to have_current_path('/')
  end
end
