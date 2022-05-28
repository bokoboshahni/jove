# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::AsteroidBeltImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:belt_ids) do
      Dir[Rails.root.join('spec/fixtures/sde/fsd/universe/**/solarsystem.staticdata')].each_with_object([]) do |path, a|
        solar_system = YAML.load_file(path)
        solar_system['planets'].each_value do |planet|
          planet['asteroidBelts']&.each_key { |belt_id| a << belt_id }
        end
      end
    end

    it 'saves each asteroid belt' do
      expect(importer.import_all.rows.flatten).to match_array(belt_ids)
    end
  end
end
