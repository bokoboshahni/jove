# frozen_string_literal: true

class RefreshESITokenJob
  include Sidekiq::Job

  def perform(*args)
    # Do something
  end
end
