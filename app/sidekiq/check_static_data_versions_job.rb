# frozen_string_literal: true

class CheckStaticDataVersionsJob
  include Sidekiq::Job

  def perform
    StaticDataVersion.check_for_new_version!
  end
end
