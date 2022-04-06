# frozen_string_literal: true

module Jove
  module Select
    class Component < Jove::Component
      def initialize(options:, name:, variant: :native, **system_args)
        super

        @name = name
        @options = options
        @variant = variant
        @system_args = system_args
        @classes = @system_args.delete(:class)
      end

      def call
        select_tag(@name, @options, class: container_classes, **@system_args)
      end

      self.container_variant_class_names = {
        native: 'block w-full pl-3 pr-10 py-1 ' \
                'border border-outline rounded-md ' \
                'bg-surface ' \
                'text-on-surface text-label-lg ' \
                'focus:outline-none focus:ring-primary-container focus:border-primary-container'
      }.freeze
    end
  end
end
