# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::MoonImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }

  describe '#import_solar_system' do
    let(:solar_system_data) do
      YAML.load_file('spec/fixtures/sde/fsd/universe/eve/TheForge/Kimotoro/Jita/solarsystem.staticdata')
    end
    let(:solar_system_id) { solar_system_data['solarSystemID'] }

    let(:moon_ids) do
      solar_system_data['planets'].values.each_with_object([]) do |planet, a|
        planet['moons']&.each_key { |id| a << id }
      end
    end

    it 'saves each moon' do
      importer.import_solar_system(solar_system_data)
      expect(Moon.pluck(:id)).to match_array(moon_ids)
    end
  end
end
