# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchMarketOrderSourceJob, type: :job do
  describe '#perform' do
    subject(:job) { described_class.new }

    let(:sources) { instance_double('ActiveRecord::Relation') }

    before do
      allow(MarketOrderSource).to receive(:enabled).and_return(sources)
      allow(sources).to receive(:find_by).and_return(source)
    end

    context 'when the source is fetchable' do
      let(:source) { create(:market_order_source, :fetched, :expired) }

      it 'fetches the source' do
        expect(source).to receive(:fetch!)
        job.perform(source.id)
      end
    end

    context 'when the source is not fetchable' do
      let(:source) { create(:market_order_source, :fetched) }

      it 'does not fetch the source' do
        expect(source).not_to receive(:fetch!)
        job.perform(source.id)
      end
    end

    context 'when the source is not enabled' do
      let(:source) { create(:market_order_source, :disabled) }

      before do
        allow(sources).to receive(:find_by).and_return(nil)
      end

      it 'does not fetch the source' do
        expect(source).not_to receive(:fetch!)
        job.perform(source.id)
      end
    end
  end
end
