# frozen_string_literal: true

require 'jove/errors'

module Jove
  module ESI
    class Error < Jove::ServiceError
      def self.for(response)
        Jove::ESI::ERROR_CODE_CLASSES.fetch(response.code, Jove::ESI::Error)
      end

      def initialize(response = nil) # rubocop:disable Metrics/MethodLength
        if response
          message = begin
            parsed = Oj.load(response.body)
            parsed['error'] if parsed
          rescue Oj::Error
            response.body
          end
          super("#{response.code} - #{message}", response)
        else
          super('Unhandled ESI error')
        end
      end
    end

    class ClientError < Error; end

    class BadRequestError < ClientError; end

    class ForbiddenError < ClientError; end

    class NotFoundError < ClientError; end

    class ErrorLimitedError < ClientError; end

    class UnprocessableEntityError < ClientError; end

    class ServerError < Error; end

    class BadGatewayError < ServerError; end

    class InternalServerError < ServerError; end

    class ServiceUnavailableError < ServerError; end

    class TimeoutError < ServerError; end

    ERROR_CODE_CLASSES = {
      400 => BadRequestError,
      403 => ForbiddenError,
      404 => NotFoundError,
      420 => ErrorLimitedError,
      422 => UnprocessableEntityError,
      500 => InternalServerError,
      502 => BadGatewayError,
      503 => ServiceUnavailableError,
      504 => TimeoutError
    }.freeze
  end
end
