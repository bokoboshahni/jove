# frozen_string_literal: true

module Jove
  module Select
    class ComponentPreview < ViewComponent::Preview
      include ActionView::Helpers::FormOptionsHelper

      # @label Native (Light)
      def native_light
        render_native
      end

      # @label Native (Dark)
      # @display theme dark
      def native_dark
        render_native
      end

      private

      def render_native
        options = ['United States', 'Canada', 'Mexico']
        render(Jove::Select::Component.new(name: 'select', options: options_for_select(options, 'Canada')))
      end
    end
  end
end
