# frozen_string_literal: true

class RefreshAllESITokensJob
  include Sidekiq::Job

  def perform
    token_ids = ESIToken.authorized.where('expires_at <= ?', Time.zone.now).pluck(:id)
    RefreshESITokenJob.perform_bulk(token_ids.map { |i| [i] }) unless token_ids.empty?
  end
end
