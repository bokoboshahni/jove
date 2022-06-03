# frozen_string_literal: true

module Jove
  module Form
    module ComboBox
      class ComponentPreview < ViewComponent::Preview
        # @label Basic (light)
        def basic_light
          render_with_template(template: 'jove/form/combo_box/component_preview/basic')
        end

        # @label Basic (dark)
        # @display theme dark
        def basic_dark
          render_with_template(template: 'jove/form/combo_box/component_preview/basic')
        end
      end
    end
  end
end
