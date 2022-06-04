# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RefreshAllESITokensJob, type: :job do
  let(:job) { described_class.new }

  describe '#perform' do
    it 'queues all authorized, expired tokens' do
      tokens = create_list(:esi_token, 2, :authorized, expires_at: 10.minutes.ago)
      expect(RefreshESITokenJob).to receive(:perform_bulk).with(tokens.map { |t| [t.id] })
      job.perform
    end

    it 'does not queue authorized, unexpired tokens' do
      create_list(:esi_token, 2, :authorized, expires_at: 10.minutes.ago)
      token = create(:esi_token, :authorized, expires_at: 10.minutes.from_now)
      expect(RefreshESITokenJob).not_to receive(:perform_bulk).with(array_including([token.id]))
      job.perform
    end

    it 'does not queue unauthorized tokens' do
      create_list(:esi_token, 2, :authorized, expires_at: 10.minutes.ago)
      token = create(:esi_token)
      expect(RefreshESITokenJob).not_to receive(:perform_bulk).with(array_including([token.id]))
      job.perform
    end
  end
end
