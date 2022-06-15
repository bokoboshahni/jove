# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchAllMarketOrderSourcesJob, type: :job do
  describe '#perform' do
    subject(:job) { described_class.new }

    it 'does not attempt to queue if there are no fetchable sources' do
      expect(FetchMarketOrderSourceJob).not_to receive(:perform_bulk)
      job.perform
    end

    it 'queues fetching for fetchable sources' do
      fetchables = create_list(:market_order_source, 2, :fetchable, :expired)
      create_list(:market_order_source, 2, :fetched)
      args = fetchables.map { |f| [f.id] }
      expect(FetchMarketOrderSourceJob).to receive(:perform_bulk).with(args)
      job.perform
    end
  end
end
