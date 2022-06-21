# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'User identity settings', type: :system do
  include_context 'User scenarios'

  scenario 'switching the current identity' do
    character = create(:character, :with_login_permit)
    create(:identity, user:, character:)

    visit(dashboard_root_path)

    click_on('Open user menu')

    click_on(character.name)
    wait_for_page_reload

    click_on('Open user menu')

    expect(page).to have_css('#current_identity_name', text: character.name)
  end

  scenario 'changing the default identity' do
    character = create(:character, :with_login_permit)
    identity = create(:identity, user:, character:)

    visit(dashboard_root_path)

    click_on('Open user menu')
    within('#user_menu') { expect(page).to have_text('Manage your account') }

    click_on('Manage your account')

    click_on('Characters')
    wait_for_page_reload

    expect(page).to have_text(character.name)

    click_on("Actions for #{character.name}")
    within("#identity_#{identity.id}_actions") { expect(page).to have_text('Make default') }

    click_on('Make default')
    wait_for_page_reload

    within("#identity_#{identity.id}") { expect(page).to have_text('Default') }
  end

  scenario 'disconnecting a character' do
    character = create(:character, :with_login_permit)
    create(:identity, user:, character:)

    visit(settings_identities_path)

    click_on("Actions for #{character.name}")

    click_on('Disconnect')

    within('#modal') { click_on 'Disconnect' }

    visit(settings_identities_path)

    expect(page).not_to have_text(character.name)
  end
end
