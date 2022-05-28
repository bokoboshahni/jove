# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::CorporationImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:corporation_ids) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/fsd/npcCorporations.yaml')).keys
    end

    it 'saves each corporation' do
      expect(importer.import_all.rows.flatten).to match_array(corporation_ids)
    end
  end
end
