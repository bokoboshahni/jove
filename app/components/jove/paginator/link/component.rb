# frozen_string_literal: true

module Jove
  module Paginator
    module Link
      class Component < Jove::Component
        def initialize(
          page:, type:, current_page:, total_pages:,
          params: {},
          param_name: nil,
          turbo_action: nil,
          **system_args
        )
          super

          @page = page
          @type = type
          @params = params
          @param_name = param_name

          @current_page = current_page
          @total_pages = total_pages

          @turbo_action = turbo_action
        end

        def first?
          @type == :first
        end

        def last?
          @type == :last
        end

        def prev?
          @type == :prev
        end

        def next?
          @type == :next
        end

        def gap?
          @type == :gap
        end

        def page?
          @type == :page
        end

        private

        self.container_class_names = 'text-on-surface'

        CONTAINER_ACTIVE_CLASSES = ''

        CONTAINER_INACTIVE_CLASSES = ''

        self.state_class_names = 'p-1 rounded-sm'

        STATE_ACTIVE_CLASSES = 'bg-surface-variant'

        STATE_INACTIVE_CLASSES = 'hover:bg-on-surface hover:bg-opacity-hover ' \
                                 'focus:bg-on-surface focus:bg-opacity-focus ' \
                                 'active:bg-on-surface active:bg-opacity-press'

        attr_reader :page, :current_page

        def container_classes
          join_classes(
            super,
            (page? && page.current? ? CONTAINER_ACTIVE_CLASSES : CONTAINER_INACTIVE_CLASSES)
          )
        end

        def state_classes
          join_classes(
            super,
            (page? && page.current? ? STATE_ACTIVE_CLASSES : STATE_INACTIVE_CLASSES)
          )
        end

        def data_attrs
          attrs = {}
          attrs[:turbo_action] = @turbo_action if @turbo_action
          attrs
        end

        # Adapted from Kaminari::Helpers::Tag

        def url
          page_url_for(@page)
        end

        def page_url_for(page)
          params = params_for(page)
          params[:only_path] = true
          url_for(params)
        end

        def params_for(page) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
          if (@param_name == :page) || !@param_name.include?('[')
            page_val = !Kaminari.config.params_on_first_page && (page <= 1) ? nil : page
            @params.merge(@param_name => page_val)
          else
            page_params = Rack::Utils.parse_nested_query("#{@param_name}=#{page}")
            page_params = @params.deep_merge(page_params)

            if !Kaminari.config.params_on_first_page && (page <= 1)
              # This converts a hash:
              #   from: {other: "params", page: 1}
              #     to: {other: "params", page: nil}
              #   (when @param_name == "page")
              #
              #   from: {other: "params", user: {name: "yuki", page: 1}}
              #     to: {other: "params", user: {name: "yuki", page: nil}}
              #   (when @param_name == "user[page]")
              @param_name.to_s.scan(/[\w.]+/)[0..-2].inject(page_params) { |h, k| h[k] }[Regexp.last_match(0)] = nil
            end

            page_params
          end
        end
      end
    end
  end
end
