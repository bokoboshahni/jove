# frozen_string_literal: true

require 'down/http'

class DownloadStaticDataVersionJob
  include Sidekiq::Job

  def perform(id)
    version = StaticDataVersion.find(id)
    version.download!
  end
end
