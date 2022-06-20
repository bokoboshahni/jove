# frozen_string_literal: true

require 'system_helper'

RSpec.describe 'Market administration', type: :system do
  include_context 'Administration scenarios'
  include_context 'Market scenarios'

  scenario 'listing markets' do
    markets = create_list(:market, 2)

    visit(admin_markets_path)

    markets.each do |market|
      expect(page).to have_text(market.name)
    end
  end

  scenario 'viewing market details' do
    market = create(:market)

    visit(admin_market_path(market))

    expect(page).to have_text(market.name)
  end
end
