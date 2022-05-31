# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auditable, type: :model do
  let(:model_class) do
    Class.new(ActiveRecord::Base) do
      include Auditable

      self.table_name = :types
    end
  end

  subject(:model) { model_class.new }

  describe '#last_modified_by' do
    let(:user) { create(:registered_user) }
    let(:identity) { user.default_identity }
    let(:log_data) { instance_double('Logidze::History') }

    before { allow(model).to receive(:log_data).and_return(log_data) }

    it 'returns the identity when responsible id is set' do
      allow(log_data).to receive(:responsible_id).and_return(identity.id.to_s)

      expect(model.last_modified_by).to eq(identity)
    end

    it 'returns nil when responsible id is not set' do
      allow(log_data).to receive(:responsible_id).and_return(nil)

      expect(model.last_modified_by).to be_nil
    end
  end
end
