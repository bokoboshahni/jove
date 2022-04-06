# frozen_string_literal: true

module Jove
  module Dropdown
    class Component < Jove::Component
      renders_one :button, lambda { |**args|
        component_args = args.merge(
          data: { action: 'jove--dropdown--component#toggle click@window->jove--dropdown--component#hide' },
          aria: { expanded: false, haspopup: true }
        )
        Jove::Button::Component.new(**component_args)
      }

      renders_one :menu

      def initialize(position: :right, wrapper_class: nil, **system_args)
        super

        @position = position
        @wrapper_class = wrapper_class
      end

      private

      POSITION_CLASSES = {
        left: 'origin-top-left left-0',
        center: '-translate-x-1/2 left-1/2',
        right: 'origin-top-right right-0'
      }.freeze

      def wrapper_classes
        join_classes(
          'absolute z-10 hidden max-w-xs px-2 mt-4 sm:px-0 transition transform',
          POSITION_CLASSES.fetch(@position),
          @wrapper_class
        )
      end
    end
  end
end
