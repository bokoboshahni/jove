# frozen_string_literal: true

module Jove
  module TurboGrid
    module Row
      class Component < Jove::Component
        renders_many :cells, Jove::TurboGrid::Cell::Component

        def initialize(**system_args)
          super

          @system_args = system_args
        end

        private

        def row_classes
          join_classes
        end

        def row_data_attrs
          {
            controller: 'jove--turbo-grid--row--component'
          }
        end
      end
    end
  end
end
