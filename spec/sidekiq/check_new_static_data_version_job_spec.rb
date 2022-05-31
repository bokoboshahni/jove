# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckNewStaticDataVersionJob, type: :job do
  describe '.check_for_new_version!' do
    before do
      stub_request(:get, Jove.config.sde_checksum_url).to_return(body: SecureRandom.hex(32))
    end

    context 'when there is a new version available' do
      it 'creates a new version' do
        expect { described_class.new.perform }.to change { StaticDataVersion.count }.by(1)
      end
    end
  end
end
