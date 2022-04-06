# frozen_string_literal: true

module Jove
  module TurboDialog
    class ComponentPreview < ViewComponent::Preview
      # @label Basic (Light)
      def basic_light
        render_dialog('basic')
      end

      # @label Basic (Dark)
      # @display theme dark
      def basic_dark
        render_dialog('basic')
      end

      # @label With Icon (Light)
      def icon_light
        render_dialog('icon')
      end

      # @label With Icon (Dark)
      # @display theme dark
      def icon_dark
        render_dialog('icon')
      end

      private

      def render_dialog(template)
        render_with_template(template: "jove/turbo_dialog/component_preview/#{template}")
      end
    end
  end
end
