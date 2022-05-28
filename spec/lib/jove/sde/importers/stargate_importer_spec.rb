# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::StargateImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:stargate_ids) do
      Dir[Rails.root.join('spec/fixtures/sde/fsd/universe/**/solarsystem.staticdata')].each_with_object([]) do |path, a|
        solar_system = YAML.load_file(path)
        next unless solar_system['stargates']

        solar_system['stargates'].each_key { |stargate_id| a << stargate_id }
      end
    end

    it 'saves each stargate' do
      expect(importer.import_all.rows.flatten).to match_array(stargate_ids)
    end
  end
end
