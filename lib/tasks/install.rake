# frozen_string_literal: true

namespace :install do # rubocop:disable Metrics/BlockLength
  desc 'Create default markets'
  task create_default_markets: :environment do # rubocop:disable Metrics/BlockLength
    transaction do # rubocop:disable Metrics/BlockLength
      default_trade_hubs = {
        'Jita' => ['Jita IV - Moon 4 - Caldari Navy Assembly Plant'],
        'Amarr' => ['Amarr VIII (Oris) - Emperor Family Academy'],
        'Rens' => ['Rens VI - Moon 8 - Brutor Tribe Treasury'],
        'Dodixie' => ['Dodixie IX - Moon 20 - Federation Navy Assembly Plant'],
        'Hek' => ['Hek VIII - Moon 12 - Boundless Creation Factory']
      }.freeze

      markets = default_trade_hubs.map do |name, station_name|
        station = Station.find_by!(name: station_name)

        {
          name:,
          description: "#{name} trade hub",
          status: :disabled,
          disabled_at: Time.zone.now,
          hub: true,
          locations_attributes: [{ location: station }],
          market_sources_attributes: [{ source_id: station.region.market_order_source.id }]
        }
      end
      markets.each { |m| create_with(m).find_or_create_by!(name: m[:name]) }

      regions = Region.eve

      sources = regions.map do |region|
        { source: region, status: :disabled }
      end
      sources.each { |s| MarketOrderSource.create_with(s).find_or_create_by!(source: s[:source]) }
      MarketOrderSource.create!(sources)

      markets = regions.includes(:market_order_source).map do |region|
        {
          name: region.name,
          description: "Regional market for #{region.name}",
          status: :disabled,
          disabled_at: Time.zone.now,
          regional: true,
          locations_attributes: [{ location: region }],
          market_sources_attributes: [{ source_id: region.market_order_source.id }]
        }
      end
      markets.each { |m| create_with(m).find_or_create_by!(name: m[:name]) }
    end
  end
end
