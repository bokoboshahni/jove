# frozen_string_literal: true

module Jove
  module Form
    module RadioGroup
      class ComponentPreview < ViewComponent::Preview
        def default
          render(Jove::Form::RadioGroup::Component.new)
        end
      end
    end
  end
end
