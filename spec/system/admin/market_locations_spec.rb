# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Market location administration', type: :system do
  include_context 'Administration scenarios'

  scenario 'adding a station location' do
    market = create(:market)
    station_operation = create(:station_operation)
    station_service = create(:station_service, id: 7)
    station_operation.services << station_service
    station = create(:station, operation: station_operation)

    visit(admin_market_path(market))

    within('#market_locations') { click_on('Add station') }
    within('#modal') do
      fill_in('Type a station name', with: station.name[0..4])
      click_text(station.name)
      click_on('Add')
    end

    visit(admin_market_path(market))

    within('#market_locations') do
      expect(page).to have_text(station.name)
    end
  end

  scenario 'removing a location' do
    market = create(:market)
    station = create(:station)
    market.locations.create!(location: station)

    visit(admin_market_path(market))

    click_on("Remove #{station.name}")

    within('#modal') { click_on('Remove') }

    visit(admin_market_path(market))

    within('#market_locations') do
      expect(page).not_to have_text(station.name)
    end
  end
end
