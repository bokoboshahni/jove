# frozen_string_literal: true

module Jove
  module TurboGrid
    class Component < Jove::Component
      include Turbo::FramesHelper

      renders_many :columns, lambda { |**args|
        Jove::TurboGrid::Column::Component.new(**args.merge(params:))
      }

      renders_many :rows, Jove::TurboGrid::Row::Component
      renders_many :footers, Jove::TurboGrid::Row::Component

      def initialize(id:, scope:, params:, **system_args)
        super

        @id = id
        @scope = scope
        @params = params
      end

      private

      self.container_class_names = 'pb-4 space-y-4 ' \
                                   'border border-outline rounded-lg'

      TABLE_CLASSES = 'w-full ' \
                      'border-collapse'

      TABLE_HEADER_CLASSES = 'border-b border-outline'

      TABLE_BODY_CLASSES = 'border-b border-outline divide-y divide-outline'

      TABLE_FOOTER_CLASSES = ''

      PAGINATOR_CLASSES = 'px-4'

      def container_data_attrs
        {
          controller: 'jove--data-grid--component'
        }
      end

      def table_classes
        join_classes(TABLE_CLASSES)
      end

      def table_data_attrs
        {}
      end

      def table_header_classes
        join_classes(TABLE_HEADER_CLASSES)
      end

      def table_header_data_attrs
        {}
      end

      def table_body_classes
        join_classes(TABLE_BODY_CLASSES)
      end

      def table_body_data_attrs
        {}
      end

      def table_footer_classes
        join_classes(TABLE_FOOTER_CLASSES)
      end

      def table_footer_data_attrs
        {}
      end

      def paginator_classes
        join_classes(PAGINATOR_CLASSES)
      end
    end
  end
end
