# frozen_string_literal: true

module Jove
  module Form
    class Component < Jove::Component
      def initialize(model: nil, scope: nil, url: nil, format: nil, **system_args)
        super

        @model = model
        @scope = scope
        @url = url
        @format = format
      end

      def call
        form_with(model: @model, scope: @scope, url: @url, format: @format, **system_args)
      end
    end
  end
end
