# frozen_string_literal: true

module Jove
  module Form
    module CheckBoxGroup
      class ComponentPreview < ViewComponent::Preview
        def default
          render(Jove::Form::CheckBoxGroup::Component.new)
        end
      end
    end
  end
end
