# frozen_string_literal: true

require 'json/add/exception'

class ImportStaticDataVersionJob
  include Sidekiq::Job

  sidekiq_options lock: :until_executed

  def perform(id)
    version = StaticDataVersion.find(id)
    version.import!
  end
end
