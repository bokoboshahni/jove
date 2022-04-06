# frozen_string_literal: true

module Jove
  module Banner
    class Component < Jove::Component
      renders_many :actions

      def initialize(color: :primary, dismissable: true, auto_dismiss: false, **system_args)
        super

        @color = color
        @dismissable = dismissable
        @auto_dismiss = auto_dismiss
      end

      private

      WRAPPER_CLASSES = 'text-body-md opacity-0 transition -translate-y-full transform ease-in-out duration-1000'

      WRAPPER_COLOR_CLASSES = {
        primary: 'bg-primary-container text-on-primary-container',
        secondary: 'bg-secondary-container text-on-secondary-container',
        tertiary: 'bg-tertiary-container text-on-tertiary-container',
        danger: 'bg-danger-container text-on-danger-container',
        success: 'bg-success-container text-on-success-container',
        notice: 'bg-notice-container text-on-notice-container'
      }.freeze

      self.container_class_names = 'max-w-3xl mx-auto pl-6 pr-2 py-2 flex items-center'

      def wrapper_classes
        join_classes(
          WRAPPER_CLASSES,
          WRAPPER_COLOR_CLASSES.fetch(@color)
        )
      end

      def data_attrs
        attrs = {
          controller: 'jove--banner--component',
          'jove--banner--component-show-class' => 'translate-y-0 opacity-100',
          'jove--banner--component-hide-class' => '-translate-y-full opacity-0'
        }
        attrs['jove--banner--component-dismiss-after-value'] = 5000 if @auto_dismiss
        attrs
      end
    end
  end
end
