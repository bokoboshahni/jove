# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::StationImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }

  describe '#import_solar_system' do
    let(:solar_system_data) do
      YAML.load_file('spec/fixtures/sde/fsd/universe/eve/TheForge/Kimotoro/Jita/solarsystem.staticdata')
    end
    let(:solar_system_id) { solar_system_data['solarSystemID'] }

    let(:station_ids) do
      fixture = Rails.root.join('spec/fixtures/sde/bsd/staStations.yaml')
      YAML.load_file(fixture).lazy.select { |s| s['solarSystemID'] == solar_system_id }
          .map { |s| s['stationID'] }
    end

    it 'saves each station' do
      importer.import_solar_system(solar_system_data)
      expect(Station.pluck(:id)).to match_array(station_ids)
    end
  end
end
