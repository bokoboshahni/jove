# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SDEImportable, type: :model do
  let!(:model) do
    Class.new do
      include SDEImportable
    end
  end

  let(:sde_path) { Rails.root.join('spec/fixtures/sde') }

  describe '.sde_names' do
    it 'maps SDE names to a hash' do
      expect(model.sde_names[1]).to eq('EVE System')
    end
  end
end
