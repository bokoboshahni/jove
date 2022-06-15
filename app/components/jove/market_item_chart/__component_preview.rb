# frozen_string_literal: true

module Jove
  module MarketItemChart
    class ComponentPreview < ViewComponent::Preview
      def default
        render(Jove::MarketItemChart::Component.new)
      end
    end
  end
end
