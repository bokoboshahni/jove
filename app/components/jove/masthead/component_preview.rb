# frozen_string_literal: true

module Jove
  module Masthead
    # @display wrapper_class ''
    class ComponentPreview < ViewComponent::Preview
      # @label Base (Light)
      def base_light
        render_masthead
      end

      # @label Base (Dark)
      # @display theme dark
      def base_dark
        render_masthead
      end

      # @label With Banner (Light)
      def banner_light
        render_masthead(banner: true)
      end

      # @label With Banner (Dark)
      # @display theme dark
      def banner_dark
        render_masthead(banner: true)
      end

      private

      def render_masthead(banner: false)
        render_with_template(
          template: 'jove/masthead/component_preview/masthead',
          locals: {
            banner:
          }
        )
      end
    end
  end
end
