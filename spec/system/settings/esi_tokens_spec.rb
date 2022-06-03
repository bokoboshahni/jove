# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'User ESI token settings', type: :system do
  include_context 'User scenarios'

  scenario 'approving a token request' do
    create(:esi_token, identity: user.default_identity)

    visit(settings_esi_tokens_path)

    click_on("Grant ESI token request for Structure discovery from #{user.default_identity.name}")

    within('#modal') { click_on('Authorize') }
    wait_for_page_reload

    expect(current_url).to match(%r{https://login\.eveonline\.com/})
  end

  scenario 'rejecting a token request' do
    create(:esi_token, identity: user.default_identity)

    visit(settings_esi_tokens_path)

    click_on("Reject ESI token request for Structure discovery from #{user.default_identity.name}")

    within('#modal') { click_on('Decline') }
    wait_for_page_reload

    expect(page).not_to have_text('Pending token requests')
  end

  scenario 'listing ESI tokens' do
    token = create(:esi_token, :authorized, identity: user.default_identity)

    visit(settings_esi_tokens_path)

    within('#tokens-grid') do
      expect(page).to have_text(token.name)
      expect(page).to have_text('Structure discovery')
    end
  end

  scenario 'revoking an ESI token' do
    token = create(:esi_token, :authorized, identity: user.default_identity)

    visit(settings_esi_tokens_path)

    click_on("Actions for token #{token.id}")

    click_on('Revoke')

    within('#modal') { click_on 'Revoke' }

    visit(settings_esi_tokens_path)

    within('#tokens-grid') { expect(page).not_to have_text(user.default_identity.name) }
  end
end
