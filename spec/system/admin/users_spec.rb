# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'User administration', type: :system do
  include_context 'Administration scenarios'

  scenario 'listing users' do
    users = create_list(:registered_user, 5)

    visit(admin_users_path)

    users.each do |user|
      expect(page).to have_text(user.name)
    end
  end

  scenario 'deleting a user' do
    user = create(:registered_user)
    name = user.name.dup

    visit(admin_users_path)

    click_on("Actions for #{name}")

    click_on('Delete')

    expect(page).to have_text('Delete user?')

    click_on('Confirm')

    expect(page).to have_text("deleted account for #{name}")
  end
end
