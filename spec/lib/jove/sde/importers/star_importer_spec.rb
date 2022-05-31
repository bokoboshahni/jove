# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::StarImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_solar_system' do
    let(:solar_system_data) do
      YAML.load_file('spec/fixtures/sde/fsd/universe/eve/TheForge/Kimotoro/Jita/solarsystem.staticdata')
    end
    let(:solar_system_id) { solar_system_data['solarSystemID'] }

    it 'saves the star' do
      star_id = solar_system_data.fetch('star').fetch('id')
      importer.import_solar_system(solar_system_data)
      expect(Star.pluck(:id)).to match_array([star_id])
    end
  end
end
