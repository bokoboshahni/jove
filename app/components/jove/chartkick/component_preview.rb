# frozen_string_literal: true

module Jove
  module Chartkick
    class ComponentPreview < ViewComponent::Preview
      def default
        render(Jove::Chartkick::Component.new)
      end
    end
  end
end
