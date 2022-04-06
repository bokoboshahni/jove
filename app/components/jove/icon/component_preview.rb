# frozen_string_literal: true

module Jove
  module Icon
    class ComponentPreview < ViewComponent::Preview
      def default
        render(Jove::Icon::Component.new(icon: 'heroicons/outline/x'))
      end
    end
  end
end
