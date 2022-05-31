# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DownloadStaticDataVersionJob, type: :job do
  describe '#perform' do
    let(:version) { create(:static_data_version, :failed) }

    subject(:job) { described_class.new }

    before do
      body = File.new(Rails.root.join('spec/fixtures/sde.zip'))
      stub_request(:get, Jove.config.sde_archive_url).to_return(body:, status: 200)

      job.perform(version.id)
      version.reload
    end

    it 'downloads the static data version' do
      expect(version).to be_downloaded
    end
  end
end
