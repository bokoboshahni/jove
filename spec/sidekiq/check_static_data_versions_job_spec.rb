# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckStaticDataVersionsJob, type: :job do
  describe '#perform' do
    before do
      stub_request(:get, Jove.config.sde_checksum_url).to_return(body: checksum)
    end

    context 'when there is a new version available' do
      let(:checksum) { SecureRandom.hex(32) }

      it 'creates a new version' do
        described_class.new.perform
        expect(StaticDataVersion.exists?(checksum:)).to be_truthy
      end
    end

    context 'when there is no new version available' do
      let(:checksum) { SecureRandom.hex(32) }

      before do
        StaticDataVersion.create!(checksum:)
      end

      it 'does not create a new version' do
        expect { described_class.new.perform }.not_to(change { StaticDataVersion.count })
      end
    end
  end
end
