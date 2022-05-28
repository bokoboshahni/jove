# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::BloodlineImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:bloodline_ids) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/fsd/bloodlines.yaml')).keys
    end

    it 'saves each bloodline' do
      expect(importer.import_all.rows.flatten).to match_array(bloodline_ids)
    end
  end
end
