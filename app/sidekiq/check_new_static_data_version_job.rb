# frozen_string_literal: true

class CheckNewStaticDataVersionJob
  include Sidekiq::Job

  def perform
    StaticDataVersion.check_for_new_version!
  end
end
