# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::PlanetImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:planet_ids) do
      Dir[Rails.root.join('spec/fixtures/sde/fsd/universe/**/solarsystem.staticdata')].each_with_object([]) do |path, a|
        solar_system = YAML.load_file(path)
        solar_system['planets'].each_key { |planet_id| a << planet_id }
      end
    end

    it 'saves each planet' do
      expect(importer.import_all.rows.flatten).to match_array(planet_ids)
    end
  end
end
