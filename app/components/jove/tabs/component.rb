# frozen_string_literal: true

module Jove
  module Tabs
    class Component < Jove::Component
      renders_many :items, Jove::Tabs::Item::Component

      self.container_class_names = 'flex items-center justify-between'
    end
  end
end
