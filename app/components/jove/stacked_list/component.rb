# frozen_string_literal: true

module Jove
  module StackedList
    class Component < Jove::Component
      renders_many :items, Jove::StackedList::Item::Component

      def initialize(tag: :ul, **system_args)
        super

        @tag = tag
      end

      self.container_class_names = 'divide-y divide-outline ' \
                                   'text-on-surface'
    end
  end
end
