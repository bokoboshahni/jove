# frozen_string_literal: true

module Jove
  module Tabs
    module Item
      class Component < Jove::Component
        def initialize(label:, icon: '', href: '#', active: false, **system_args)
          super

          @label = label
          @icon = icon
          @href = href
          @active = active

          @system_args = system_args
        end

        private

        self.container_class_names = 'flex-1 border-b-2 text-title-md'

        CONTAINER_ACTIVE_CLASSES = 'border-primary-container text-on-surface'

        CONTAINER_INACTIVE_CLASSES = 'border-transparent text-on-surface-variant ' \
                                     'hover:border-primary hover:border-opacity-hover '

        self.state_class_names = 'flex flex-col items-center px-4 pt-3 pb-[.625rem]'

        STATE_ACTIVE_CLASSES = ''

        STATE_INACTIVE_CLASSES = 'hover:bg-primary hover:bg-opacity-hover ' \
                                 'focus:bg-primary focus:bg-opacity-focus ' \
                                 'active:bg-primary active:bg-opacity-press'

        ICON_CLASSES = ''

        ICON_ACTIVE_CLASSES = ''

        ICON_INACTIVE_CLASSES = ''

        def container_classes
          join_classes(
            super,
            @active ? CONTAINER_ACTIVE_CLASSES : CONTAINER_INACTIVE_CLASSES
          )
        end

        def state_classes
          join_classes(
            super,
            @active ? STATE_ACTIVE_CLASSES : STATE_INACTIVE_CLASSES
          )
        end

        def icon_classes
          join_classes(
            ICON_CLASSES,
            @active ? ICON_ACTIVE_CLASSES : ICON_INACTIVE_CLASSES
          )
        end
      end
    end
  end
end
