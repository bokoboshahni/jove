# frozen_string_literal: true

module Jove
  module Badge
    class Component < Jove::Component
      def initialize(label: nil, icon: nil, color: :primary, **system_args)
        super

        @label = label
        @icon = icon
        @color = color

        @system_args = system_args
        @classes = system_args.delete(:class)
      end

      private

      self.container_class_names = 'inline-flex items-center ' \
                                   'rounded-sm ' \
                                   'text-label-sm'

      self.container_color_class_names = {
        disabled: 'bg-on-surface bg-opacity-disabled-container text-on-surface text-opacity-disabled-content',
        primary: 'bg-primary text-on-primary',
        secondary: 'bg-secondary text-on-secondary',
        tertiary: 'bg-tertiary text-on-tertiary',
        danger: 'bg-danger text-on-danger',
        success: 'bg-success text-on-success',
        notice: 'bg-notice text-on-notice',
        neutral: 'bg-surface-variant text-on-surface-variant'
      }.freeze

      ICON_CLASSES = ''

      ICON_COLOR_CLASSES = {
        disabled: '',
        primary: '',
        secondary: '',
        tertiary: '',
        danger: '',
        success: '',
        notice: '',
        neutral: '',
        neutral_variant: ''
      }.freeze

      def container_classes
        join_classes(
          super,
          @label.blank? && @icon.present? ? 'p-1' : 'px-2 py-1'
        )
      end

      def icon_classes
        join_classes(
          ICON_CLASSES,
          ICON_COLOR_CLASSES.fetch(@color),
          @label.blank? ? '' : '-ml-1 mr-1'
        )
      end
    end
  end
end
