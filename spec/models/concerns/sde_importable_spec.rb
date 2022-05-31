# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SDEImportable, type: :model do
  let(:model_class) do
    Class.new(ActiveRecord::Base) do
      include SDEImportable

      self.table_name = :types
    end
  end

  subject(:model) { model_class.new }

  describe '#static_data_version' do
    let(:log_data) { instance_double('Logidze::History') }

    before { allow(model).to receive(:log_data).and_return(log_data) }

    it 'returns the static data version when responsible id is set' do
      version = create(:static_data_version)
      allow(log_data).to receive(:responsible_id).and_return(version.id.to_s)

      expect(model.static_data_version).to eq(version)
    end

    it 'returns nil when responsible id is not set' do
      allow(log_data).to receive(:responsible_id).and_return(nil)

      expect(model.static_data_version).to be_nil
    end
  end
end
