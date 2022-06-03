# frozen_string_literal: true

module Jove
  module Form
    module ComboBox
      module Item
        class Component < Jove::Component
          def initialize(label:, value:, icon_url: nil, selected: false, **system_args)
            super(**system_args)

            @label = label
            @value = value
            @icon_url = icon_url
            @selected = selected
          end

          self.container_class_names = 'w-full cursor-pointer ' \
                                       'rounded-lg'

          self.state_class_names = 'h-8 flex items-center px-3 space-y-3 ' \
                                   'hover:bg-on-surface hover:bg-opacity-hover ' \
                                   'focus:bg-on-surface focus:bg-opacity-focus ' \
                                   'active:bg-on-surface active:bg-opacity-press ' \
                                   'disabled:text-opacity-disabled-container'
        end
      end
    end
  end
end
