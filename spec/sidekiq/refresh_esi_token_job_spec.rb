# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RefreshESITokenJob, type: :job do
  let(:job) { described_class.new }

  describe '#perform' do
    let(:token) { create(:esi_token, :authorized) }

    before { allow(ESIToken).to receive(:find).with(token.id).and_return(token) }

    it 'refreshes the token if expired' do
      allow(token).to receive(:current_token_expired?).and_return(true)
      expect(token).to receive(:refresh!)
      job.perform(token.id)
    end

    it 'does not refresh the token if not expired' do
      allow(token).to receive(:current_token_expired?).and_return(false)
      expect(token).not_to receive(:refresh!)
      job.perform(token.id)
    end
  end
end
