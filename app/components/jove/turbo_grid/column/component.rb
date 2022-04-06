# frozen_string_literal: true

module Jove
  module TurboGrid
    module Column
      class Component < Jove::Component
        def initialize(
          label: nil,
          id: nil,
          actions: false,
          sortable: true,
          sorted: false,
          sort_dir: nil,
          align: :left,
          params: {},
          **system_args
        )
          super

          @label = label
          @id = (id || @label.parameterize(separator: '_')) if @label
          @actions = actions
          @sortable = sortable
          @sorted = sorted
          @sort_dir = sort_dir
          @align = align

          @system_args = system_args
          @classes = @system_args.delete(:class)
        end

        private

        COLUMN_CLASSES = 'px-4 py-2 ' \
                         'text-label-lg font-medium'

        ALIGN_CLASSES = {
          left: 'text-left',
          center: 'text-center',
          right: 'text-right'
        }.freeze

        SORT_ICONS = {
          unsorted: 'heroicons/outline/selector',
          asc: 'heroicons/outline/chevron-up',
          desc: 'heroicons/outline/chevron-down'
        }.freeze

        def column_classes
          join_classes(
            COLUMN_CLASSES,
            ALIGN_CLASSES.fetch(@align),
            @classes
          )
        end

        def column_data_attrs
          {
            controller: 'jove--turbo-grid--column--component'
          }
        end

        def sort_link_classes
          join_classes(
            'inline-flex items-center'
          )
        end

        def sort_icon
          return SORT_ICONS.fetch(:unsorted) unless @sorted

          SORT_ICONS.fetch(@sort_dir.to_sym)
        end

        def sort_dir_param
          return 'asc' unless @sorted

          @sort_dir == 'asc' ? 'desc' : 'asc'
        end

        def sort_url
          url_for(params.to_unsafe_h.merge(sort: @id, dir: sort_dir_param))
        end
      end
    end
  end
end
