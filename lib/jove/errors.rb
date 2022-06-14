# frozen_string_literal: true

require 'json/add/exception'

module Jove
  class Error < StandardError
  end

  class ServiceError < Error
    attr_reader :response

    def initialize(message, response = nil)
      @response = response

      super(message)
    end

    def as_json(options = nil) # rubocop:disable Metrics/MethodLength
      if response
        super(options).merge!(
          response: {
            body: response.body,
            headers: response.headers,
            status: response.code,
            url: response.effective_url
          }
        )
      else
        super(options)
      end
    end
  end
end
