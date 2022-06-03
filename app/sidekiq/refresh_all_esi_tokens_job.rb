# frozen_string_literal: true

class RefreshAllESITokensJob
  include Sidekiq::Job

  def perform(*args)
    # Do something
  end
end
