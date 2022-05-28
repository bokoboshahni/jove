# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::MoonImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:moon_ids) do
      Dir[Rails.root.join('spec/fixtures/sde/fsd/universe/**/solarsystem.staticdata')].each_with_object([]) do |path, a|
        solar_system = YAML.load_file(path)
        solar_system['planets'].each_value do |planet|
          planet['moons']&.each_key { |moon_id| a << moon_id }
        end
      end
    end

    it 'saves each moon' do
      expect(importer.import_all.rows.flatten).to match_array(moon_ids)
    end
  end
end
