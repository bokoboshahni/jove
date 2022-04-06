# frozen_string_literal: true

module Jove
  module Badge
    class ComponentPreview < ViewComponent::Preview
      # @!group Light

      # @label Primary
      def primary_light
        render_badges(:primary)
      end

      # @label Secondary
      def secondary_light
        render_badges(:secondary)
      end

      # @label Tertiary
      def tertiary_light
        render_badges(:tertiary)
      end

      # @label Danger
      def danger_light
        render_badges(:danger)
      end

      # @label Success
      def success_light
        render_badges(:success)
      end

      # @label Notice
      def notice_light
        render_badges(:notice)
      end

      # @label Neutral
      def neutral_light
        render_badges(:neutral)
      end

      # @label Disabled
      def disabled_light
        render_badges(:disabled)
      end

      # @!endgroup

      # @!group Dark

      # @label Primary
      # @display theme dark
      def primary_dark
        render_badges(:primary)
      end

      # @label Secondary
      # @display theme dark
      def secondary_dark
        render_badges(:secondary)
      end

      # @label Tertiary
      # @display theme dark
      def tertiary_dark
        render_badges(:tertiary)
      end

      # @label Danger
      # @display theme dark
      def danger_dark
        render_badges(:danger)
      end

      # @label Success
      # @display theme dark
      def success_dark
        render_badges(:success)
      end

      # @label Notice
      # @display theme dark
      def notice_dark
        render_badges(:notice)
      end

      # @label Neutral
      # @display theme dark
      def neutral_dark
        render_badges(:neutral)
      end

      # @label Disabled
      # @display theme dark
      def disabled_dark
        render_badges(:disabled)
      end

      # @!endgroup

      private

      def render_badges(color)
        render_with_template(
          template: 'jove/badge/component_preview/badges',
          locals: {
            color:
          }
        )
      end
    end
  end
end
