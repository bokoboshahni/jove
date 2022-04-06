# frozen_string_literal: true

module Jove
  module Form
    class ComponentPreview < ViewComponent::Preview
      def default
        render(Jove::Form::Component.new)
      end
    end
  end
end
