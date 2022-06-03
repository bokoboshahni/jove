# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Structures administration', type: :system do
  include_context 'Administration scenarios'

  scenario 'requesting a token for structure discovery', search: true do
    user = create(:registered_user)
    identity = user.default_identity

    visit(admin_structures_path)

    click_on('Request token')

    within('#modal') do
      fill_in('Search for character', with: identity.name[0..3])
      click_text(identity.name)
      click_on('Request')
    end

    wait_for_page_reload

    expect(page).to have_text(identity.name)
    expect(page).to have_text('Structure discovery')
  end

  scenario 'listing structures' do
    structures = create_list(:structure, 2)

    visit(admin_structures_path)

    structures.each do |structure|
      expect(page).to have_text(structure.name)
    end
  end
end
