# frozen_string_literal: true

module Jove
  class Component < ViewComponent::Base
    include ViewComponent::PolymorphicSlots

    SURFACE_COLORS = 'bg-surface text-on-surface'

    PRIMARY_COLORS = 'bg-primary text-on-primary'
    SECONDARY_COLORS = 'bg-secondary text-on-secondary'
    TERTIARY_COLORS = 'bg-tertiary text-on-tertiary'
    DANGER_COLORS = 'bg-danger text-on-danger'
    SUCCESS_COLORS = 'bg-success text-on-success'
    NOTICE_COLORS = 'bg-notice text-on-notice'

    PRIMARY_CONTAINER_COLORS = 'bg-primary-container text-on-primary-container'
    SECONDARY_CONTAINER_COLORS = 'bg-secondary-container text-on-secondary-container'
    TERTIARY_CONTAINER_COLORS = 'bg-tertiary-container text-on-tertiary-container'
    DANGER_CONTAINER_COLORS = 'bg-danger-container text-on-danger-container'
    SUCCESS_CONTAINER_COLORS = 'bg-success-container text-on-success-container'
    NOTICE_CONTAINER_COLORS = 'bg-notice-container text-on-notice-container'

    PRIMARY_STATES = 'hover:bg-primary hover:bg-opacity-hover ' \
                     'focus:bg-primary focus:bg-opacity-focus ' \
                     'active:bg-primary active:bg-opacity-press'

    SECONDARY_STATES = 'hover:bg-secondary hover:bg-opacity-hover ' \
                       'focus:bg-secondary focus:bg-opacity-focus ' \
                       'active:bg-secondary active:bg-opacity-press'

    TERTIARY_STATES = 'hover:bg-tertiary hover:bg-opacity-hover ' \
                      'focus:bg-tertiary focus:bg-opacity-focus ' \
                      'active:bg-tertiary active:bg-opacity-press'

    DANGER_STATES = 'hover:bg-danger hover:bg-opacity-hover ' \
                    'focus:bg-danger focus:bg-opacity-focus ' \
                    'active:bg-danger active:bg-opacity-press'

    SUCCESS_STATES = 'hover:bg-success hover:bg-opacity-hover ' \
                     'focus:bg-success focus:bg-opacity-focus ' \
                     'active:bg-success active:bg-opacity-press'

    NOTICE_STATES = 'hover:bg-notice hover:bg-opacity-hover ' \
                    'focus:bg-notice focus:bg-opacity-focus ' \
                    'active:bg-notice active:bg-opacity-press'

    ON_PRIMARY_STATES = 'hover:bg-on-primary hover:bg-opacity-hover ' \
                        'focus:bg-on-primary focus:bg-opacity-focus ' \
                        'active:bg-on-primary active:bg-opacity-press'

    ON_SECONDARY_STATES = 'hover:bg-on-secondary hover:bg-opacity-hover ' \
                          'focus:bg-on-secondary focus:bg-opacity-focus ' \
                          'active:bg-on-secondary active:bg-opacity-press'

    ON_TERTIARY_STATES = 'hover:bg-on-tertiary hover:bg-opacity-hover ' \
                         'focus:bg-on-tertiary focus:bg-opacity-focus ' \
                         'active:bg-on-tertiary active:bg-opacity-press'

    ON_DANGER_STATES = 'hover:bg-on-danger hover:bg-opacity-hover ' \
                       'focus:bg-on-danger focus:bg-opacity-focus ' \
                       'active:bg-on-danger active:bg-opacity-press'

    ON_SUCCESS_STATES = 'hover:bg-on-success hover:bg-opacity-hover ' \
                        'focus:bg-on-success focus:bg-opacity-focus ' \
                        'active:bg-on-success active:bg-opacity-press'

    ON_NOTICE_STATES = 'hover:bg-on-notice hover:bg-opacity-hover ' \
                       'focus:bg-on-notice focus:bg-opacity-focus ' \
                       'active:bg-on-notice active:bg-opacity-press'

    def initialize(**system_args)
      super

      @system_args = system_args
      @variant = @system_args.delete(:variant)
      @color = @system_args.delete(:color)
      @active = @system_args.delete(:active)
      @classes = @system_args.delete(:class)
      @container_classes = @system_args.delete(:container_classes)
      @elevation_classes = @system_args.delete(:elevation_classes)
      @state_classes = @system_args.delete(:state_classes)
    end

    private

    class_attribute :variant_colors
    self.variant_colors = false

    class_attribute :class_names
    self.class_names = []

    class_attribute :variant_class_names
    self.variant_class_names = {}

    class_attribute :color_class_names
    self.color_class_names = {}

    class_attribute :container_class_names
    self.container_class_names = []

    class_attribute :container_variant_class_names
    self.container_variant_class_names = {}

    class_attribute :container_color_class_names
    self.container_color_class_names = {}

    class_attribute :elevation_class_names
    self.elevation_class_names = []

    class_attribute :elevation_variant_class_names
    self.elevation_variant_class_names = {}

    class_attribute :elevation_color_class_names
    self.elevation_color_class_names = {}

    class_attribute :state_class_names
    self.state_class_names = []

    class_attribute :state_variant_class_names
    self.state_variant_class_names = {}

    class_attribute :state_color_class_names
    self.state_color_class_names = {}

    def classes
      join_classes(
        class_names,
        variant_class_names[@variant],
        color_class_names[@color],
        @classes
      )
    end

    def container_classes
      join_classes(
        container_class_names,
        container_variant_class_names[@variant],
        (variant_colors ? container_color_class_names.dig(@variant, @color) : container_color_class_names[@color]),
        @container_classes
      )
    end

    def elevation_classes
      join_classes(
        elevation_class_names,
        elevation_variant_class_names[@variant],
        (variant_colors ? elevation_color_class_names.dig(@variant, @color) : elevation_color_class_names[@color]),
        @elevation_classes
      )
    end

    def state_classes
      join_classes(
        state_class_names,
        state_variant_class_names[@variant],
        (variant_colors ? state_color_class_names.dig(@variant, @color) : state_color_class_names[@color]),
        @state_classes
      )
    end

    def join_classes(*args)
      class_names = args.flatten.compact.uniq
      class_names.reject! { |c| class_names.include?("!#{c}") }
      class_names.join(' ')
    end
  end
end
