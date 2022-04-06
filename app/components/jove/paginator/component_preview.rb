# frozen_string_literal: true

module Jove
  module Paginator
    class ComponentPreview < ViewComponent::Preview
      # @label Basic (Light)
      def basic_light
        render_basic
      end

      # @!group High Page Count (Light)

      # @label Viewing page 2
      def high_page_count_page_2_light
        render_high_page_count(2)
      end

      # @label Viewing page 250
      def high_page_count_page_250_light
        render_high_page_count(250)
      end

      # @label Viewing page 28
      def high_page_count_page_28_light
        render_high_page_count(28)
      end

      # @!endgroup

      # @label Basic (Dark)
      # @display theme dark
      def basic_dark
        render_basic
      end

      # @!group High Page Count (Dark)

      # @label Viewing page 2
      # @display theme dark
      def high_page_count_page_2_dark
        render_high_page_count(2)
      end

      # @label Viewing page 250
      # @display theme dark
      def high_page_count_page_250_dark
        render_high_page_count(250)
      end

      # @label Viewing page 28
      # @display theme dark
      def high_page_count_page_28_dark
        render_high_page_count(28)
      end

      # @!endgroup

      private

      def render_basic
        items = [*1..100]
        scope = Kaminari.paginate_array(items).page(2).per(25)
        render(Jove::Paginator::Component.new(scope:, params: { controller: 'admin/users', action: 'index' }))
      end

      def render_high_page_count(page)
        items = [*1..5000]
        scope = Kaminari.paginate_array(items).page(page).per(20)
        render(Jove::Paginator::Component.new(scope:, params: { controller: 'admin/users', action: 'index' }))
      end
    end
  end
end
