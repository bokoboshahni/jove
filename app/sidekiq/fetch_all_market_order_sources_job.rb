# frozen_string_literal: true

class FetchAllMarketOrderSourcesJob
  include Sidekiq::Job

  sidekiq_options queue: 'critical', lock: :until_and_while_executing, lock_timeout: 1, on_conflict: :log

  def perform
    fetchable_source_ids = MarketOrderSource.fetchable.map(&:id)
    return if fetchable_source_ids.empty?

    FetchMarketOrderSourceJob.perform_bulk(fetchable_source_ids.map { |i| [i] })
  end
end
