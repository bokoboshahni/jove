# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::SolarSystemImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:solar_system_data) do
      Dir[Rails.root.join('spec/fixtures/sde/fsd/universe/**/solarsystem.staticdata')].map do |path|
        YAML.load_file(path)
      end
    end

    let(:solar_system_ids) { solar_system_data.map { |r| r['solarSystemID'] } }

    it 'saves each solar system' do
      importer.import_all
      expect(SolarSystem.pluck(:id)).to match_array(solar_system_ids)
    end
  end
end
