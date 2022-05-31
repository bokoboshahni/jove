# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::AsteroidBeltImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }

  describe '#import_all' do
    let(:solar_system_data) do
      YAML.load_file('spec/fixtures/sde/fsd/universe/eve/TheForge/Kimotoro/Jita/solarsystem.staticdata')
    end
    let(:solar_system_id) { solar_system_data['solarSystemID'] }

    let(:belt_ids) do
      solar_system_data['planets'].values.each_with_object([]) do |planet, a|
        planet['asteroidBelts']&.each_key { |id| a << id }
      end
    end

    it 'saves each belt' do
      importer.import_solar_system(solar_system_data)
      expect(AsteroidBelt.pluck(:id)).to match_array(belt_ids)
    end
  end
end
