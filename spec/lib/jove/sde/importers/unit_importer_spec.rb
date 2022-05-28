# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::UnitImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:unit_ids) do
      CSV.read(Rails.root.join('db/units.csv'), headers: true).map { |r| r['unitID'].to_i }
    end

    it 'saves each unit' do
      expect(importer.import_all.rows.flatten).to match_array(unit_ids)
    end
  end
end
