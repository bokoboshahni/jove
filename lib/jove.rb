# frozen_string_literal: true

require_relative 'jove/configuration'

module Jove
  class << self
    def configuration
      @configuration ||= Configuration.new
    end
    alias config configuration
  end
end
