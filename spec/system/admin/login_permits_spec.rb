# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Login permit administration', type: :system, vcr: true do
  let(:admin) { create(:admin_user) }

  before do
    sign_in(admin)
  end

  describe 'listing login permits' do
    it 'lists all login permits' do
      login_permits = create_list(:login_permit, 5)

      visit(dashboard_root_path)
      click_on('Administration')
      click_on('Authentication')

      login_permits.each do |login_permit|
        expect(page).to have_text(login_permit.name)
      end
    end
  end

  describe 'creating a login permit', js: true do
    it 'creates the login permit' do
      visit(dashboard_root_path)

      click_on('Administration')
      click_on('Authentication')

      click_on('Authorize')

      within('#modal') do
        choose('Alliance')
        fill_in('ID', with: '99010079')
        click_on('Authorize')
      end

      expect(page).to have_text('Brave United')
    end
  end

  describe 'deleting a login permit', js: true do
    it 'deletes the login permit' do
      login_permit = create(:login_permit)
      name = login_permit.permittable.name

      visit(dashboard_root_path)

      click_on('Administration')
      click_on('Authentication')

      click_on("Delete #{name}")

      within('#modal') { click_on('Delete') }

      expect(page).to have_text("deleted authorization for #{name}")
      click_on('Dismiss')

      expect(page).not_to have_text(name)
    end
  end
end
