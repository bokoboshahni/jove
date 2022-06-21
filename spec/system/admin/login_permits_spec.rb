# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Login permit administration', type: :system, vcr: true do
  include_context 'Administration scenarios'

  scenario 'creating a login permit' do
    visit(admin_login_permits_path)

    click_on('Authorize')

    within('#modal') do
      choose('Alliance')
      fill_in('ID', with: '99010079')
      click_on('Authorize')
    end

    wait_for_page_reload

    expect(page).to have_text('authorized Brave United')
    click_on('Dismiss')

    expect(page).to have_text('Brave United')
  end

  scenario 'deleting a login permit' do
    login_permit = create(:login_permit)
    name = login_permit.permittable.name

    visit(admin_login_permits_path)

    click_on("Delete #{name}")

    within('#modal') { click_on('Delete') }

    expect(page).to have_text("deleted authorization for #{name}")
    click_on('Dismiss')

    expect(page).not_to have_text(name)
  end
end
