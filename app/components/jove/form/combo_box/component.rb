# frozen_string_literal: true

module Jove
  module Form
    module ComboBox
      class Component < Jove::Form::Input::Component
        self.field_type = 'hidden'

        renders_many :items, Jove::Form::ComboBox::Item::Component

        def initialize(autocomplete_url: nil, **system_args)
          super(**system_args)

          @autocomplete_url = autocomplete_url
        end

        private

        MENU_CONTAINER_CLASSES = 'absolute max-h-56 z-40 w-full mt-1 space-y-2 overflow-auto ' \
                                 'rounded-md shadow-elevation-3 ' \
                                 'bg-surface ' \
                                 'text-label-lg text-on-surface '

        MENU_ELEVATION_CLASSES = 'py-2 space-y-2 ' \
                                 'rounded-md ' \
                                 'bg-primary bg-opacity-elevation-3'

        def menu_container_classes
          join_classes(MENU_CONTAINER_CLASSES)
        end

        def menu_elevation_classes
          join_classes(MENU_ELEVATION_CLASSES)
        end
      end
    end
  end
end
