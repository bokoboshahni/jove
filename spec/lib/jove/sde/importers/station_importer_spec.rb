# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::StationImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:station_ids) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/bsd/staStations.yaml')).map { |s| s['stationID'] }
    end

    it 'saves each station' do
      expect(importer.import_all.rows.flatten).to match_array(station_ids)
    end
  end
end
