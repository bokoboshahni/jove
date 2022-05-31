# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportStaticDataVersionJob, type: :job do
  describe '#perform' do
    let(:version) { create(:static_data_version, :downloaded) }

    subject(:job) { described_class.new }

    before do
      job.perform(version.id)
      version.reload
    end

    it 'imports the version' do
      expect(version).to be_imported
    end
  end
end
