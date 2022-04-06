# frozen_string_literal: true

module Jove
  module Button
    class Component < Jove::Component
      def initialize(label:, tag: :button, variant: :filled, color: :primary, value: nil, **system_args) # rubocop:disable Metrics/MethodLength
        super

        @tag = tag
        @variant = variant
        @color = @system_args[:disabled] ? :disabled : color
        @label = label
        @value = value

        @avatar = @system_args[:avatar]
        @disabled = @system_args[:disabled]
        @leading_icon = @system_args[:leading_icon]
        @trailing_icon = @system_args[:trailing_icon]

        @title = @label if %i[overflow avatar icon].include?(@variant)
      end

      private

      self.variant_colors = true

      self.container_variant_class_names = {
        elevated: 'max-h-10 ' \
                  'rounded-full shadow-elevation-1 ' \
                  'text-label-lg ' \
                  'hover:shadow-elevation-2 disabled:shadow-none',
        filled: 'rounded-full shadow-none ' \
                'text-label-lg ' \
                'hover:shadow-elevation-1 disabled:shadow-none focus:shadow-none active:shadow-none',
        outlined: 'rounded-full border border-outline ' \
                  'text-label-lg',
        text: 'rounded-full ' \
              'text-label-lg',
        overflow: 'rounded-full ',
        avatar: 'max-h-10 rounded-full '
      }.freeze

      self.container_color_class_names = {
        elevated: {
          disabled: 'bg-on-surface bg-opacity-disabled-container text-on-surface text-opacity-disabled-content',
          primary: 'text-primary',
          secondary: 'text-secondary',
          tertiary: 'text-tertiary',
          danger: 'text-danger',
          success: 'text-success',
          notice: 'text-notice'
        },
        filled: {
          disabled: 'bg-on-surface bg-opacity-disabled-container text-on-surface text-opacity-disabled-content',
          primary: 'bg-primary text-on-primary',
          secondary: 'bg-secondary text-on-secondary',
          tertiary: 'bg-tertiary text-on-tertiary',
          danger: 'bg-danger text-on-danger',
          success: 'bg-success text-on-success',
          notice: 'bg-notice text-on-notice'
        },
        outlined: {
          disabled: 'text-on-surface text-opacity-disabled-content border-opacity-disabled-container',
          primary: 'text-primary',
          secondary: 'text-secondary',
          tertiary: 'text-tertiary',
          danger: 'text-danger',
          success: 'text-success',
          notice: 'text-notice'
        },
        text: {
          disabled: 'text-on-surface text-opacity-disabled-content',
          primary: 'text-primary',
          secondary: 'text-secondary',
          tertiary: 'text-tertiary',
          danger: 'text-danger',
          success: 'text-success',
          notice: 'text-notice'
        },
        overflow: {
          disabled: 'text-on-surface text-opacity-disabled-content',
          surface: 'text-on-surface'
        },
        avatar: {
          disabled: 'text-on-surface text-opacity-disabled-content',
          primary: 'text-primary'
        }
      }.freeze

      self.elevation_variant_class_names = {
        elevated: 'rounded-full bg-opacity-elevation-1 ' \
                  'hover:bg-opacity-elevation-2 disabled:bg-opacity-elevation-1',
        filled: 'rounded-full ' \
                'hover:bg-opacity-elevation-5 ',
        outlined: 'rounded-full',
        text: 'rounded-full',
        overflow: 'rounded-full',
        avatar: 'max-h-10 rounded-full'
      }.freeze

      self.elevation_color_class_names = {
        elevated: {
          disabled: '',
          primary: 'bg-primary',
          secondary: 'bg-secondary',
          tertiary: 'bg-tertiary',
          danger: 'bg-danger',
          success: 'bg-success',
          notice: 'bg-notice'
        },
        filled: {
          disabled: '',
          primary: 'hover:bg-primary',
          secondary: 'hover:bg-secondary',
          tertiary: 'hover:bg-tertiary',
          danger: 'hover:bg-danger',
          success: 'hover:bg-success',
          notice: 'hover:bg-notice'
        },
        outlined: {
          disabled: '',
          primary: '',
          secondary: '',
          tertiary: '',
          danger: '',
          success: '',
          notice: ''
        },
        text: {
          disabled: '',
          primary: '',
          secondary: '',
          tertiary: '',
          danger: '',
          success: '',
          notice: ''
        },
        overflow: {
          disabled: '',
          primary: '',
          secondary: '',
          tertiary: '',
          danger: '',
          success: '',
          notice: ''
        },
        avatar: {
          disabled: '',
          primary: ''
        }
      }.freeze

      self.state_variant_class_names = {
        elevated: 'inline-flex items-center px-6 py-2 ' \
                  'rounded-full',
        filled: 'inline-flex items-center px-6 py-2 ' \
                'rounded-full',
        outlined: 'inline-flex items-center px-6 py-2 ' \
                  'rounded-full ',
        text: 'inline-flex items-center px-6 py-2 ' \
              'rounded-full ',
        overflow: 'inline-flex items-center px-2 py-2 ' \
                  'rounded-full ',
        avatar: 'inline-flex items-center px-1 py-1 ' \
                'rounded-full '
      }.freeze

      self.state_color_class_names = {
        elevated: {
          disabled: '',
          primary: 'hover:bg-primary hover:bg-opacity-hover ' \
                   'focus:bg-primary focus:bg-opacity-focus ' \
                   'active:bg-primary active:bg-opacity-press',
          secondary: 'hover:bg-secondary hover:bg-opacity-hover ' \
                     'focus:bg-secondary focus:bg-opacity-focus ' \
                     'active:bg-secondary active:bg-opacity-press',
          tertiary: 'hover:bg-tertiary hover:bg-opacity-hover ' \
                    'focus:bg-tertiary focus:bg-opacity-focus ' \
                    'active:bg-tertiary active:bg-opacity-press',
          danger: 'hover:bg-danger hover:bg-opacity-hover ' \
                  'focus:bg-danger focus:bg-opacity-focus ' \
                  'active:bg-danger active:bg-opacity-press',
          success: 'hover:bg-success hover:bg-opacity-hover ' \
                   'focus:bg-success focus:bg-opacity-focus ' \
                   'active:bg-success active:bg-opacity-press',
          notice: 'hover:bg-notice hover:bg-opacity-hover ' \
                  'focus:bg-notice focus:bg-opacity-focus ' \
                  'active:bg-notice active:bg-opacity-press'
        },
        filled: {
          disabled: '',
          primary: 'hover:bg-on-primary hover:bg-opacity-hover ' \
                   'focus:bg-on-primary focus:bg-opacity-focus ' \
                   'active:bg-on-primary active:bg-opacity-press',
          secondary: 'hover:bg-on-secondary hover:bg-opacity-hover ' \
                     'focus:bg-on-secondary focus:bg-opacity-focus ' \
                     'active:bg-on-secondary active:bg-opacity-press',
          tertiary: 'hover:bg-on-tertiary hover:bg-opacity-hover ' \
                    'focus:bg-on-tertiary focus:bg-opacity-focus ' \
                    'active:bg-on-tertiary active:bg-opacity-press',
          danger: 'hover:bg-on-danger hover:bg-opacity-hover ' \
                  'focus:bg-on-danger focus:bg-opacity-focus ' \
                  'active:bg-on-danger active:bg-opacity-press',
          success: 'hover:bg-on-success hover:bg-opacity-hover ' \
                   'focus:bg-on-success focus:bg-opacity-focus ' \
                   'active:bg-on-success active:bg-opacity-press',
          notice: 'hover:bg-on-notice hover:bg-opacity-hover ' \
                  'focus:bg-on-notice focus:bg-opacity-focus ' \
                  'active:bg-on-notice active:bg-opacity-press'
        },
        outlined: {
          disabled: '',
          primary: 'hover:bg-primary hover:bg-opacity-hover ' \
                   'focus:bg-primary focus:bg-opacity-focus ' \
                   'active:bg-primary active:bg-opacity-press',
          secondary: 'hover:bg-secondary hover:bg-opacity-hover ' \
                     'focus:bg-secondary focus:bg-opacity-focus ' \
                     'active:bg-secondary active:bg-opacity-press',
          tertiary: 'hover:bg-tertiary hover:bg-opacity-hover ' \
                    'focus:bg-tertiary focus:bg-opacity-focus ' \
                    'active:bg-tertiary active:bg-opacity-press',
          danger: 'hover:bg-danger hover:bg-opacity-hover ' \
                  'focus:bg-danger focus:bg-opacity-focus ' \
                  'active:bg-danger active:bg-opacity-press',
          success: 'hover:bg-success hover:bg-opacity-hover ' \
                   'focus:bg-success focus:bg-opacity-focus ' \
                   'active:bg-success active:bg-opacity-press',
          notice: 'hover:bg-notice hover:bg-opacity-hover ' \
                  'focus:bg-notice focus:bg-opacity-focus ' \
                  'active:bg-notice active:bg-opacity-press'
        },
        text: {
          disabled: '',
          primary: 'hover:bg-primary hover:bg-opacity-hover ' \
                   'focus:bg-primary focus:bg-opacity-focus ' \
                   'active:bg-primary active:bg-opacity-press',
          secondary: 'hover:bg-secondary hover:bg-opacity-hover ' \
                     'focus:bg-secondary focus:bg-opacity-focus ' \
                     'active:bg-secondary active:bg-opacity-press',
          tertiary: 'hover:bg-tertiary hover:bg-opacity-hover ' \
                    'focus:bg-tertiary focus:bg-opacity-focus ' \
                    'active:bg-tertiary active:bg-opacity-press',
          danger: 'hover:bg-danger hover:bg-opacity-hover ' \
                  'focus:bg-danger focus:bg-opacity-focus ' \
                  'active:bg-danger active:bg-opacity-press',
          success: 'hover:bg-success hover:bg-opacity-hover ' \
                   'focus:bg-success focus:bg-opacity-focus ' \
                   'active:bg-success active:bg-opacity-press',
          notice: 'hover:bg-notice hover:bg-opacity-hover ' \
                  'focus:bg-notice focus:bg-opacity-focus ' \
                  'active:bg-notice active:bg-opacity-press'
        },
        overflow: {
          disabled: '',
          surface: 'hover:bg-on-surface hover:bg-opacity-hover ' \
                   'focus:bg-on-surface focus:bg-opacity-focus ' \
                   'active:bg-on-surface active:bg-opacity-press'
        },
        avatar: {
          disabled: '',
          primary: 'hover:bg-primary hover:bg-opacity-hover ' \
                   'focus:bg-primary focus:bg-opacity-focus ' \
                   'active:bg-primary active:bg-opacity-press'
        }
      }.freeze

      def elevation_classes
        return '' if @disabled

        super
      end

      def leading_icon_classes
        [
          ('-ml-1 mr-2' if @label.present?)
        ].flatten.compact.uniq.join(' ')
      end

      def trailing_icon_classes
        [
          ('ml-2 -mr-1' if @label.present?)
        ].flatten.compact.uniq.join(' ')
      end
    end
  end
end
