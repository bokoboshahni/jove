# frozen_string_literal: true

module Jove
  module Tabs
    class ComponentPreview < ViewComponent::Preview
      def light
        render_tabs
      end

      # @display theme dark
      def dark
        render_tabs
      end

      private

      def render_tabs
        render_with_template(template: 'jove/tabs/component_preview/tabs')
      end
    end
  end
end
