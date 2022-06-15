# frozen_string_literal: true

class FetchMarketOrderSourceJob
  include Sidekiq::Job
  include Sidekiq::Throttled::Worker

  sidekiq_options queue: 'high', lock: :until_and_while_executing, lock_timeout: 5, on_conflict: :log

  sidekiq_throttle concurrency: { limit: 10 }

  def perform(id)
    source = MarketOrderSource.enabled.find_by(id:)
    return unless source&.fetchable?

    source.fetch!

    # args = source.markets.enabled.select(&:aggregatable?).map { |m| [m.id] }
    # AggregateMarketJob.perform_bulk(args)
  end
end
