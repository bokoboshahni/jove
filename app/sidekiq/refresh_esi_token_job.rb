# frozen_string_literal: true

class RefreshESITokenJob
  include Sidekiq::Job

  def perform(id)
    token = ESIToken.find(id)
    token.refresh! if token&.current_token_expired?
  end
end
