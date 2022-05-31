# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::StargateImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }

  describe '#import_all' do
    let(:solar_system_data) do
      YAML.load_file('spec/fixtures/sde/fsd/universe/eve/TheForge/Kimotoro/Jita/solarsystem.staticdata')
    end
    let(:solar_system_id) { solar_system_data['solarSystemID'] }

    let(:stargate_ids) do
      solar_system_data['stargates'].keys
    end

    it 'saves each stargate' do
      importer.import_solar_system(solar_system_data)
      expect(Stargate.pluck(:id)).to match_array(stargate_ids)
    end
  end
end
