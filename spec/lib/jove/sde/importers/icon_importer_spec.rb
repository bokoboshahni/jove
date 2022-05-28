# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::IconImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:icon_ids) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/fsd/iconIDs.yaml')).keys
    end

    it 'saves each icon' do
      expect(importer.import_all.rows.flatten).to match_array(icon_ids)
    end
  end
end
