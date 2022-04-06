# frozen_string_literal: true

module Jove
  module StackedList
    module Item
      class Component < Jove::Component
        renders_one :leading, types: {
          avatar: ->(url) { image_tag(url, class: 'h-10 w-10 rounded-full') }
        }

        renders_one :headline
        renders_one :body

        renders_one :trailer

        def initialize(tag: :li, menu_title: nil, **system_args)
          super

          @tag = tag
          @menu_title = menu_title
        end

        self.container_class_names = 'p-4'
      end
    end
  end
end
