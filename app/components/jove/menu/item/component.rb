# frozen_string_literal: true

module Jove
  module Menu
    module Item
      class Component < Jove::Component
        def initialize(
          label:,
          tag: :a,
          leading_icon: nil,
          trailing_icon: nil,
          form: false,
          method: :get,
          href: nil,
          **system_args
        )
          super

          @tag = tag
          @label = label
          @leading_icon = leading_icon
          @trailing_icon = trailing_icon
          @form = form
          @method = method
          @href = href
          @system_args = system_args
        end

        private

        self.container_class_names = 'w-full cursor-pointer ' \
                                     'rounded-lg'

        self.state_class_names = 'h-8 flex items-center px-3 space-y-3 ' \
                                 'hover:bg-on-surface hover:bg-opacity-hover ' \
                                 'focus:bg-on-surface focus:bg-opacity-focus ' \
                                 'active:bg-on-surface active:bg-opacity-press ' \
                                 'disabled:text-opacity-disabled-container'

        def leading_icon_classes
          join_classes('shrink-0 -ml-1 mr-2 text-on-surface-variant')
        end

        def trailing_icon_classes
          join_classes('shrink-0 ml-2 -mr-1 text-on-surface-variant')
        end
      end
    end
  end
end
