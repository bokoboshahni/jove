# frozen_string_literal: true

module Jove
  module Menu
    class ComponentPreview < ViewComponent::Preview
      def light
        render_menu
      end

      # @display theme dark
      def dark
        render_menu
      end

      private

      def render_menu
        render_with_template(template: 'jove/menu/component_preview/menu')
      end
    end
  end
end
