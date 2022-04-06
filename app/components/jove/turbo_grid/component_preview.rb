# frozen_string_literal: true

module Jove
  module TurboGrid
    class ComponentPreview < ViewComponent::Preview
      def default
        render(Jove::TurboGrid::Component.new)
      end
    end
  end
end
