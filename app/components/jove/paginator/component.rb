# frozen_string_literal: true

module Jove
  module Paginator
    class Component < Jove::Component
      def initialize( # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        scope:,
        params: {},
        param_name: :page,
        window: nil,
        outer_window: 0,
        left: 1,
        right: 1,
        inner_window: 2,
        row_name: nil,
        page_sizes: [10, 25, 50, 100],
        turbo_action: nil,
        turbo_frame: nil,
        **system_args
      )
        super

        @scope = scope

        @params = params
        @params = params.to_unsafe_h if params.respond_to?(:to_unsafe_h)
        @params = @params.with_indifferent_access
        @params.except!(*PARAM_KEY_EXCEPT_LIST)
        @param_name = param_name

        @total_pages = @scope.total_pages
        @per_page = @scope.limit_value

        @window = window || inner_window
        @left = left.zero? ? outer_window : left
        @right = right.zero? ? outer_window : right
        @last = nil

        @window_options = { window: @window, left: @left, right: @right, total_pages: @total_pages }
        @current_page = @window_options[:current_page] = PageProxy.new(@window_options, scope.current_page, nil)

        @row_name = row_name
        @page_sizes = page_sizes

        @turbo_action = turbo_action
        @turbo_frame = turbo_frame

        @system_args = system_args
      end

      private

      PARAM_KEY_EXCEPT_LIST = %i[authenticity_token commit utf8 _method script_name original_script_name].freeze

      attr_reader :params, :param_name, :current_page, :total_pages

      self.container_class_names = 'grid grid-cols-3 gap-4 items-center text-label-lg text-on-surface'

      INFO_CLASSES = 'flex items-center'

      SIZER_CLASSES = 'flex items-center justify-center space-x-2'

      PAGINATOR_CLASSES = 'flex items-center justify-end py-2 space-x-1'

      def info_classes
        join_classes(INFO_CLASSES)
      end

      def sizer_classes
        join_classes(SIZER_CLASSES)
      end

      def sizer_select_classes; end

      def paginator_classes
        join_classes(PAGINATOR_CLASSES)
      end

      # Adapted from Kaminari::Helpers::Paginator

      def each_page
        pages.each do |page|
          yield PageProxy.new(@window_options, page, @last)
        end
      end

      def pages
        left_window_plus_one = [*1..@left + 1]
        right_window_plus_one = [*@total_pages - @right..@total_pages]
        inside_window_plus_each_sides = [*@current_page - @window - 1..@current_page + @window + 1]

        (left_window_plus_one | inside_window_plus_each_sides | right_window_plus_one).sort.reject do |x|
          (x < 1) || (x > @total_pages)
        end
      end

      def render_link(type, page = nil) # rubocop:disable Metrics/MethodLength
        page = case type
               when :first
                 1
               when :last
                 @total_pages
               when :prev
                 @current_page - 1
               when :next
                 @current_page + 1
               when :gap
                 nil
               when :page
                 page
               end

        @last = component = Jove::Paginator::Link::Component.new(page:, type:, params:, param_name:, current_page:,
                                                                 total_pages:, turbo_action: @turbo_action)
        render(component)
      end

      def row_name
        if @row_name
          @row_name.pluralize(@scope.size, I18n.locale)
        else
          @scope.entry_name(count: @scope.size).downcase
        end
      end

      def page_sizes_for_select
        options_for_select(@page_sizes.map { |s| [s, s] }, @per_page)
      end

      def info
        if @scope.total_pages < 2
          t('.info.one_page.rows', row_name:, count: @scope.total_count)
        else
          from = @scope.offset_value + 1
          to   = @scope.offset_value + (@scope.respond_to?(:records) ? @scope.records : @scope.to_a).size

          t('.info.more_pages.rows', row_name:, first: from, last: to, total: @scope.total_count)
        end
      end

      class PageProxy < Kaminari::Helpers::Paginator::PageProxy
        def was_truncated?
          @last&.gap?
        end
      end
    end
  end
end
