# frozen_string_literal: true

module Jove
  module Menu
    module Group
      class Component < Jove::Component
        renders_many :items, Jove::Menu::Item::Component
      end
    end
  end
end
