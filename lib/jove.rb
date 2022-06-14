# frozen_string_literal: true

require_relative 'jove/configuration'

module Jove
  PROJECT_URL = 'https://github.com/bokoboshahni/jove'

  VERSION = File.read(File.expand_path('../VERSION', File.dirname(__FILE__))).strip

  class << self
    def configuration
      @configuration ||= Configuration.new
    end
    alias config configuration

    def project_url
      Jove::PROJECT_URL
    end

    def version_url
      "https://github.com/bokoboshahni/jove/releases/tag/v#{Jove::VERSION}"
    end

    def hydra
      @hydra ||= Typhoeus::Hydra.new(max_concurrency: 150)
    end
  end
end
