# frozen_string_literal: true

module Jove
  module Dropdown
    class ComponentPreview < ViewComponent::Preview
      # @!group Position (Light)

      # @label Left
      def position_left_light
        render_dropdown(:left, 'justify-start')
      end

      # @label Center
      def position_center_light
        render_dropdown(:center, 'justify-center')
      end

      # @label Right
      def position_right_light
        render_dropdown(:right, 'justify-end')
      end

      # @!endgroup

      # @!group Position (Dark)

      # @label Left
      # @display theme dark
      def position_left_dark
        render_dropdown(:left, 'justify-start')
      end

      # @label Center
      # @display theme dark
      def position_center_dark
        render_dropdown(:center, 'justify-center')
      end

      # @label Right
      # @display theme dark
      def position_right_dark
        render_dropdown(:right, 'justify-end')
      end

      # @!endgroup

      private

      def render_dropdown(position, wrapper)
        render_with_template(
          template: 'jove/dropdown/component_preview/dropdown',
          locals: {
            position:,
            wrapper:
          }
        )
      end
    end
  end
end
