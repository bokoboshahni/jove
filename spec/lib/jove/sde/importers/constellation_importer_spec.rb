# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::ConstellationImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:constellation_data) do
      Dir[Rails.root.join('spec/fixtures/sde/fsd/universe/**/constellation.staticdata')].map do |constellation_path|
        YAML.load_file(constellation_path)
      end
    end

    let(:constellation_ids) { constellation_data.map { |r| r['constellationID'] } }

    it 'saves each constellation' do
      importer.import_all
      expect(Constellation.pluck(:id)).to match_array(constellation_ids)
    end
  end
end
