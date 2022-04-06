# frozen_string_literal: true

module Jove
  module ThemeToggle
    class ComponentPreview < ViewComponent::Preview
      # @display theme_toggle true
      def default
        render(Jove::ThemeToggle::Component.new)
      end
    end
  end
end
