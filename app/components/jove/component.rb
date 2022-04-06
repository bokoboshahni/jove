# frozen_string_literal: true

module Jove
  class Component < ViewComponent::Base
    include ViewComponent::PolymorphicSlots

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
