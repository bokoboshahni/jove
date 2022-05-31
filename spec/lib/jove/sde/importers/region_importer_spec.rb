# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::RegionImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:region_data) do
      Dir[Rails.root.join('spec/fixtures/sde/fsd/universe/**/region.staticdata')].map do |region_path|
        YAML.load_file(region_path)
      end
    end

    let(:region_ids) { region_data.map { |r| r['regionID'] } }

    it 'saves each region' do
      importer.import_all
      expect(Region.pluck(:id)).to match_array(region_ids)
    end
  end
end
