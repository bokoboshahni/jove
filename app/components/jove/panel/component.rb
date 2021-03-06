# frozen_string_literal: true

module Jove
  module Panel
    class Component < Jove::Component
      def initialize(tag: :div, variant: :elevated, color: :surface, **system_args)
        super

        @tag = tag
      end

      self.variant_colors = true

      self.container_variant_class_names = {
        elevated: 'rounded-xl shadow-elevation-1 ' \
                  'hover:shadow-elevation-2',
        filled: 'rounded-xl ' \
                'hover:shadow-elevation-1 focus:shadow-none active:shadow-none',
        outlined: 'rounded-xl border border-outline'
      }.freeze

      self.container_color_class_names = {
        elevated: {
          surface: Jove::Component::SURFACE_COLORS,
          primary: Jove::Component::PRIMARY_CONTAINER_COLORS,
          secondary: Jove::Component::SECONDARY_CONTAINER_COLORS,
          tertiary: Jove::Component::TERTIARY_CONTAINER_COLORS,
          danger: Jove::Component::DANGER_CONTAINER_COLORS,
          success: Jove::Component::SUCCESS_CONTAINER_COLORS,
          notice: Jove::Component::NOTICE_CONTAINER_COLORS
        },
        filled: {
          surface: Jove::Component::SURFACE_COLORS,
          primary: Jove::Component::PRIMARY_COLORS,
          secondary: Jove::Component::SECONDARY_COLORS,
          tertiary: Jove::Component::TERTIARY_COLORS,
          danger: Jove::Component::DANGER_COLORS,
          success: Jove::Component::SUCCESS_COLORS,
          notice: Jove::Component::NOTICE_COLORS
        },
        outlined: {
          surface: 'text-surface',
          primary: 'text-primary',
          secondary: 'text-secondary',
          tertiary: 'text-tertiary',
          danger: 'text-danger',
          success: 'text-success',
          notice: 'text-notice'
        }
      }.freeze

      self.elevation_variant_class_names = {
        elevated: 'rounded-xl bg-opacity-elevation-1 ' \
                  'hover:bg-opacity-elevation-2',
        filled: 'rounded-xl ' \
                'bg-transparent ' \
                'hover:bg-opacity-elevation-5 ' \
                'focus:bg-transparent ' \
                'active:bg-transparent',
        outlined: 'rounded-xl'
      }.freeze

      self.elevation_color_class_names = {
        elevated: {
          surface: 'bg-primary',
          primary: 'bg-primary',
          secondary: 'bg-secondary',
          tertiary: 'bg-tertiary',
          danger: 'bg-danger',
          success: 'bg-success',
          notice: 'bg-notice'
        },
        filled: {
          surface: 'hover:bg-primary',
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
        }
      }.freeze

      self.state_variant_class_names = {
        elevated: 'rounded-xl',
        filled: 'rounded-xl',
        outlined: 'rounded-xl'
      }.freeze

      self.state_color_class_names = {
        elevated: {
          surface: '',
          primary: Jove::Component::PRIMARY_STATES,
          secondary: Jove::Component::SECONDARY_STATES,
          tertiary: Jove::Component::TERTIARY_STATES,
          danger: Jove::Component::DANGER_STATES,
          success: Jove::Component::SUCCESS_STATES,
          notice: Jove::Component::NOTICE_STATES
        },
        filled: {
          surface: '',
          primary: Jove::Component::ON_PRIMARY_STATES,
          secondary: Jove::Component::ON_SECONDARY_STATES,
          tertiary: Jove::Component::ON_TERTIARY_STATES,
          danger: Jove::Component::ON_DANGER_STATES,
          success: Jove::Component::ON_SUCCESS_STATES,
          notice: Jove::Component::ON_NOTICE_STATES
        },
        outlined: {
          surface: '',
          primary: Jove::Component::PRIMARY_STATES,
          secondary: Jove::Component::SECONDARY_STATES,
          tertiary: Jove::Component::TERTIARY_STATES,
          danger: Jove::Component::DANGER_STATES,
          success: Jove::Component::SUCCESS_STATES,
          notice: Jove::Component::NOTICE_STATES
        }
      }.freeze
    end
  end
end
