# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::InventoryFlagImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }

  describe '#import_all' do
    let(:flag_ids) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/bsd/invFlags.yaml')).map { |f| f['flagID'] }
    end

    it 'saves each flag' do
      importer.import_all
      expect(InventoryFlag.pluck(:id)).to match_array(flag_ids)
    end
  end
end
