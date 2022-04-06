# frozen_string_literal: true

module Guidelines
  module Spacing
    class ComponentPreview < ViewComponent::Preview
      include ActionView::Context

      def scale; end

      # @!group Padding

      # @label 1
      # @display wrapper_class "p-4 max-w-xs"
      def padding_01
        padding('p-1')
      end

      # @label 2
      # @display wrapper_class "p-4 max-w-xs"
      def padding_02
        padding('p-2')
      end

      # @label 3
      # @display wrapper_class "p-4 max-w-xs"
      def padding_03
        padding('p-3')
      end

      # @label 4
      # @display wrapper_class "p-4 max-w-xs"
      def padding_04
        padding('p-4')
      end

      # @label 6
      # @display wrapper_class "p-4 max-w-xs"
      def padding_06
        padding('p-6')
      end

      # @label 8
      # @display wrapper_class "p-4 max-w-xs"
      def padding_08
        padding('p-8')
      end

      # @label 16
      # @display wrapper_class "p-4 max-w-xs"
      def padding_16
        padding('p-16')
      end

      # @!endgroup

      private

      def padding(class_name)
        render_with_template(template: 'guidelines/spacing/component_preview/padding',
                             locals: { padding_class: class_name })
      end
    end
  end
end
