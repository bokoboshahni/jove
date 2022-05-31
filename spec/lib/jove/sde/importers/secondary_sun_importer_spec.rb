# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::SecondarySunImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }

  describe '#import_solar_system' do
    let(:solar_system_data) do
      YAML.load_file('spec/fixtures/sde/fsd/universe/wormhole/A-R00001/A-C00312/J105711/solarsystem.staticdata')
    end
    let(:solar_system_id) { solar_system_data['solarSystemID'] }

    it 'saves the secondary sun' do
      sun_id = solar_system_data.fetch('secondarySun').fetch('itemID')
      importer.import_solar_system(solar_system_data)
      expect(SecondarySun.pluck(:id)).to match_array([sun_id])
    end
  end
end
