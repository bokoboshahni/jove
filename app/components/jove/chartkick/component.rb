# frozen_string_literal: true

module Jove
  module Chartkick
    class Component < Jove::Component
      include ::Chartkick::Helper

      def initialize(data:, type: :line, **system_args)
        super

        @type = type
        @data = data
      end

      def call
        send(:"#{@type}_chart", @data, **@system_args)
      end
    end
  end
end
