# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'User administration', type: :system do
  let(:admin) { create(:admin_user) }

  before do
    sign_in(admin)
  end

  describe 'listing users' do
    it 'lists registered users' do
      users = create_list(:registered_user, 5)

      visit(dashboard_root_path)
      click_on('Administration')
      click_on('Users')

      users.each do |user|
        expect(page).to have_text(user.name)
      end
    end
  end

  describe 'deleting a user', js: true do
    it 'deletes the user' do
      user = create(:registered_user)
      name = user.name.dup

      visit admin_users_path

      click_on "Actions for #{name}"

      click_on 'Delete'

      expect(page).to have_text('Delete user?')

      click_on 'Confirm'

      expect(page).to have_text("deleted account for #{name}")
    end
  end
end
