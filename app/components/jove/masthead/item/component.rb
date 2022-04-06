# frozen_string_literal: true

module Jove
  module Masthead
    module Item
      class Component < Jove::Component
        renders_one :menu

        def initialize(label:, href: nil, active: false, **system_args)
          super(**system_args)

          @label = label
          @href = href
          @active = active
        end

        private

        self.container_class_names = 'border-b-2 flex items-center text-title-md'

        ITEM_CONTAINER_ACTIVE_CLASSES = 'border-primary-container text-on-surface'

        ITEM_CONTAINER_INACTIVE_CLASSES = 'border-transparent text-on-surface-variant ' \
                                          'hover:border-primary hover:border-opacity-hover '

        self.state_class_names = 'flex items-center px-4 pt-3 pb-[.625rem]'

        ITEM_STATE_ACTIVE_CLASSES = ''

        ITEM_STATE_INACTIVE_CLASSES = 'hover:bg-primary hover:bg-opacity-hover ' \
                                      'focus:bg-primary focus:bg-opacity-focus ' \
                                      'active:bg-primary active:bg-opacity-press'

        def menu_wrapper_classes
          join_classes(
            '-translate-x-1/2 left-1/2',
            'absolute z-10 hidden w-screen max-w-xs px-2 mt-4 sm:px-0 transition transform'
          )
        end

        def menu_container_classes
          join_classes(
            'overflow-hidden',
            'rounded-xl shadow-elevation-2',
            'bg-surface text-on-surface'
          )
        end

        def menu_elevation_classes
          join_classes(
            'rounded-xl',
            'bg-primary bg-opacity-elevation-2'
          )
        end

        def container_classes
          join_classes(
            super,
            @active ? ITEM_CONTAINER_ACTIVE_CLASSES : ITEM_CONTAINER_INACTIVE_CLASSES
          )
        end

        def state_classes
          join_classes(
            super,
            @active ? ITEM_STATE_ACTIVE_CLASSES : ITEM_STATE_INACTIVE_CLASSES
          )
        end

        def dropdown_attrs
          {
            data: { action: 'jove--dropdown--component#toggle click@window->jove--dropdown--component#hide' },
            aria: { expanded: false, haspopup: true }
          }
        end
      end
    end
  end
end
