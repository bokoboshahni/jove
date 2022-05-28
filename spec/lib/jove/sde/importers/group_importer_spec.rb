# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::GroupImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:group_ids) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/fsd/groupIDs.yaml')).keys
    end

    it 'saves each group' do
      expect(importer.import_all.rows.flatten).to match_array(group_ids)
    end
  end
end
