# frozen_string_literal: true

module Jove
  module Banner
    class ComponentPreview < ViewComponent::Preview
      # @!group Basic (Light)

      # @label Primary
      def primary_light
        render_basic(:primary)
      end

      # @label Secondary
      def secondary_light
        render_basic(:secondary)
      end

      # @label Tertiary
      def tertiary_light
        render_basic(:tertiary)
      end

      # @label Danger
      def danger_light
        render_basic(:danger)
      end

      # @label Success
      def success_light
        render_basic(:success)
      end

      # @label Notice
      def notice_light
        render_basic(:notice)
      end

      # @!endgroup

      # @!group Basic (Dark)

      # @label Primary
      # @display theme dark
      def primary_dark
        render_basic(:primary)
      end

      # @label Secondary
      # @display theme dark
      def secondary_dark
        render_basic(:secondary)
      end

      # @label Tertiary
      # @display theme dark
      def tertiary_dark
        render_basic(:tertiary)
      end

      # @label Danger
      # @display theme dark
      def danger_dark
        render_basic(:danger)
      end

      # @label Success
      # @display theme dark
      def success_dark
        render_basic(:success)
      end

      # @label Notice
      # @display theme dark
      def notice_dark
        render_basic(:notice)
      end

      # @!endgroup

      private

      BANNER_TEXT = 'One line text string with two actions.'

      def render_basic(color)
        render_with_template(
          template: 'jove/banner/component_preview/basic',
          locals: {
            color:
          }
        )
      end
    end
  end
end
