# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::MetaGroupImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:meta_group_ids) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/fsd/metaGroups.yaml')).keys
    end

    it 'saves each meta group' do
      importer.import_all
      expect(MetaGroup.pluck(:id)).to match_array(meta_group_ids)
    end
  end
end
