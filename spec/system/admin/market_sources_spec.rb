# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Market sources administration', type: :system do
  include_context 'Administration scenarios'
  include_context 'Market scenarios'

  scenario 'adding a region source' do
    market = create(:market)
    region = create(:region)
    region.create_market_order_source

    visit(admin_market_path(market))

    within('#market_sources') { click_on('Add region') }
    within('#modal') do
      fill_in('Type a region name', with: region.name[0..4])
      click_text(region.name)
      click_on('Add')
    end

    visit(admin_market_path(market))

    within('#market_sources') do
      expect(page).to have_text(region.name)
    end
  end

  scenario 'removing a source' do
    market = create(:market)
    region = create(:region)
    source = region.create_market_order_source
    market.market_sources.create!(source:)

    visit(admin_market_path(market))

    click_on("Remove #{source.name}")

    within('#modal') { click_on('Remove') }

    visit(admin_market_path(market))

    within('#market_sources') do
      expect(page).not_to have_text(source.name)
    end
  end
end
