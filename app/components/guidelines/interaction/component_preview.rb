# frozen_string_literal: true

module Guidelines
  module Interaction
    class ComponentPreview < ViewComponent::Preview
      # @!group States (light)

      # @label Hover
      def hover_light; end

      # @label Focus
      def focus_light; end

      # @label Active
      def active_light; end

      # @!endgroup

      # @!group States (dark)

      # @label Hover
      # @display theme dark
      def hover_dark; end

      # @label Focus
      # @display theme dark
      def focus_dark; end

      # @label Active
      # @display theme dark
      def active_dark; end

      # @!endgroup
    end
  end
end
