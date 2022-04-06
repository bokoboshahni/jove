# frozen_string_literal: true

module Jove
  module TurboGrid
    module Cell
      class Component < Jove::Component
        def initialize(align: :left, **system_args)
          super

          @align = align

          @system_args = system_args
          @classes = @system_args.delete(:class)
        end

        def call
          tag.td(class: cell_classes, data: cell_data_attrs) { content }
        end

        private

        CELL_CLASSES = 'px-4 py-2 ' \
                       'text-body-md'

        ALIGN_CLASSES = {
          left: 'text-left',
          center: 'text-center',
          right: 'text-right'
        }.freeze

        def cell_classes
          join_classes(
            CELL_CLASSES,
            ALIGN_CLASSES.fetch(@align),
            @classes
          )
        end

        def cell_data_attrs
          {
            controller: 'jove--turbo-grid--cell--component'
          }
        end
      end
    end
  end
end
