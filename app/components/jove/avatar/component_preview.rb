# frozen_string_literal: true

module Jove
  module Avatar
    class ComponentPreview < ViewComponent::Preview
      def default
        render(Jove::Avatar::Component.new(src: 'https://images.evetech.net/characters/2113024536/portrait'))
      end
    end
  end
end
