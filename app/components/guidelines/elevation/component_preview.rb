# frozen_string_literal: true

module Guidelines
  module Elevation
    class ComponentPreview < ViewComponent::Preview
      def light
        render_with_template(template: 'guidelines/elevation/component_preview/default')
      end

      # @display theme dark
      def dark
        render_with_template(template: 'guidelines/elevation/component_preview/default')
      end
    end
  end
end
