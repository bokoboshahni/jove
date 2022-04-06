# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Authorization behavior', type: :system do
  it 'disallows the action and shows the user an error when not authorized' do
    user = create(:registered_user)
    sign_in(user)

    visit admin_root_path

    expect(page).not_to have_text('Administration')
    expect(page).to have_text('not authorized')
  end
end
