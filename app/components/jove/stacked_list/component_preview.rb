# frozen_string_literal: true

module Jove
  module StackedList
    class ComponentPreview < ViewComponent::Preview
      def light
        render_list
      end

      # @display theme dark
      def dark
        render_list
      end

      private

      def render_list
        render_with_template(template: 'jove/stacked_list/component_preview/list')
      end
    end
  end
end
