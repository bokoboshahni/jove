# frozen_string_literal: true

module Jove
  module Panel
    class ComponentPreview < ViewComponent::Preview
      # @!group Elevated (Light)

      # @label Surface
      def elevated_surface_light
        render_panels(:elevated, :surface)
      end

      # @label Primary
      def elevated_primary_light
        render_panels(:elevated, :primary)
      end

      # @label Secondary
      def elevated_secondary_light
        render_panels(:elevated, :secondary)
      end

      # @label Tertiary
      def elevated_tertiary_light
        render_panels(:elevated, :tertiary)
      end

      # @label Danger
      def elevated_danger_light
        render_panels(:elevated, :danger)
      end

      # @label Success
      def elevated_success_light
        render_panels(:elevated, :success)
      end

      # @label Notice
      def elevated_notice_light
        render_panels(:elevated, :notice)
      end

      # @!endgroup

      # @!group Elevated (Dark)

      # @label Surface
      # @display theme dark
      def elevated_surface_dark
        render_panels(:elevated, :surface)
      end

      # @label Primary
      # @display theme dark
      def elevated_primary_dark
        render_panels(:elevated, :primary)
      end

      # @label Secondary
      # @display theme dark
      def elevated_secondary_dark
        render_panels(:elevated, :secondary)
      end

      # @label Tertiary
      # @display theme dark
      def elevated_tertiary_dark
        render_panels(:elevated, :tertiary)
      end

      # @label Danger
      # @display theme dark
      def elevated_danger_dark
        render_panels(:elevated, :danger)
      end

      # @label Success
      # @display theme dark
      def elevated_success_dark
        render_panels(:elevated, :success)
      end

      # @label Notice
      # @display theme dark
      def elevated_notice_dark
        render_panels(:elevated, :notice)
      end

      # @!endgroup

      private

      def render_panels(variant, color)
        render_with_template(
          template: 'jove/panel/component_preview/panels',
          locals: {
            variant:,
            color:
          }
        )
      end
    end
  end
end
