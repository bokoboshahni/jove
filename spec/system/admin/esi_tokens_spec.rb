# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'ESI token administration', type: :system do
  include_context 'Administration scenarios'

  scenario 'listing ESI tokens' do
    users = create_list(:registered_user, 2)
    identities = users.map(&:default_identity)
    tokens = identities.map { |i| create(:esi_token, identity: i) }

    visit(admin_esi_tokens_path)

    tokens.each { |a| expect(page).to have_text(a.name) }
  end

  scenario 'destroying an ESI token' do
    token = create(:esi_token)
    identity = token.identity

    visit(admin_esi_tokens_path)

    click_on("Actions for token #{token.id}")

    click_on('Revoke')

    within('#modal') do
      click_on 'Revoke'
      wait_for_page_reload
    end

    visit(admin_esi_tokens_path)

    within('#tokens-grid') { expect(page).not_to have_text(identity.name) }
  end
end
