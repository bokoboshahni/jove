# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Static data version administration', type: :system do
  include_context 'Administration scenarios'

  scenario 'listing static data versions' do
    versions = create_list(:static_data_version, 5)

    visit(admin_static_data_versions_path)

    versions.each do |version|
      expect(page).to have_text(version.checksum)
    end
  end

  scenario 'checking for a new static data version when a new version is available' do
    checksum = SecureRandom.hex(32)
    stub_request(:get, Jove.config.sde_checksum_url).to_return(body: checksum)

    visit(admin_static_data_versions_path)

    click_on('Check for new version')
    wait_for_page_reload

    expect(page).to have_text(checksum)
    expect(page).to have_text('New static data version available!')
  end

  scenario 'checking for a new static data version when no new version is available' do
    checksum = SecureRandom.hex(32)
    create(:static_data_version, checksum:)
    stub_request(:get, Jove.config.sde_checksum_url).to_return(body: checksum)

    visit(admin_static_data_versions_path)

    click_on('Check for new version')
    wait_for_page_reload

    expect(page).to have_text(checksum)
    expect(page).to have_text('No new static data version is available.')
  end

  scenario 'downloading a static data version' do
    version = create(:static_data_version)

    visit(admin_static_data_versions_path)

    click_on("Actions for #{version.id}")
    click_on('Download')

    expect(page).to have_text('Download?')

    click_on('Confirm')

    expect(page).to have_text("queued static data version ##{version.id} for download")
  end

  scenario 'importing a static data version' do
    version = create(:static_data_version, :downloaded)

    visit(admin_static_data_versions_path)

    click_on("Actions for #{version.id}")
    click_on('Import')

    expect(page).to have_text('Import?')

    click_on('Confirm')

    expect(page).to have_text("queued static data version ##{version.id} for import")
  end
end
