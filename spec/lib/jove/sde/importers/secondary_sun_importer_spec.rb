# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::SecondarySunImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:sun_ids) do
      Dir[Rails.root.join('spec/fixtures/sde/fsd/universe/**/solarsystem.staticdata')].each_with_object([]) do |path, a|
        solar_system = YAML.load_file(path)
        next unless solar_system['secondarySun']

        a << solar_system['secondarySun']['itemID']
      end
    end

    it 'saves each sun' do
      expect(importer.import_all.rows.flatten).to match_array(sun_ids)
    end
  end
end
