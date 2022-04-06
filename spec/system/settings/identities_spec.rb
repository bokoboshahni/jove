# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'User identity settings', type: :system do
  let(:user) { create(:registered_user) }

  before do
    sign_in(user)
  end

  describe 'switching the current identity' do
    it 'changes the current identity' do
      character = create(:character, :with_login_permit)
      create(:identity, user:, character:)

      visit dashboard_root_path

      click_on('Open user menu')

      click_on(character.name)

      click_on('Open user menu')

      expect(page).to have_css('#current_identity_name', text: character.name)
    end
  end

  describe 'changing the default identity' do
    it 'changes the default identity' do
      character = create(:character, :with_login_permit)
      identity = create(:identity, user:, character:)

      visit(dashboard_root_path)

      click_on('Open user menu')
      click_on('Manage your account')
      click_on('Characters')
      click_on("Actions for #{character.name}")
      click_on('Make default')

      within("#identity_#{identity.id}") { expect(page).to have_text('Default') }
    end
  end

  describe 'listing characters' do
    it "lists the current user's characters" do
      characters = create_list(:character, 5, :with_login_permit)
      characters.each { |character| create(:identity, user:, character:) }

      visit settings_identities_path

      user.characters.each do |character|
        expect(page).to have_text(character.name)
      end
    end
  end

  describe 'disconnecting a character' do
    it 'disconnects the character' do
      character = create(:character, :with_login_permit)
      create(:identity, user:, character:)

      visit settings_identities_path

      click_on "Actions for #{character.name}"

      click_on 'Disconnect'

      within('#modal') { click_on 'Disconnect' }

      visit settings_identities_path

      expect(page).not_to have_text(character.name)
    end
  end
end
