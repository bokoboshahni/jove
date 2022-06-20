# frozen_string_literal: true

module Jove
  module Icon
    class Component < Jove::Component
      def initialize(icon:, size: 6, **tag_options)
        super

        @icon = icon
        @size = size
        @tag_options = tag_options
        @classes = @tag_options.delete(:class)
      end

      def call
        file = Rails.cache.fetch(@icon) do
          File.read(Rails.root.join("vendor/icons/#{@icon}.svg")).force_encoding('UTF-8')
        end
        doc = Nokogiri::HTML::DocumentFragment.parse(file)
        svg = doc.at_css('svg')

        @tag_options[:class] = classes
        @tag_options.each { |k, v| svg[k.to_s] = v }

        raw(doc)
      end

      private

      SIZE_CLASSES = {
        3 => 'h-3 w-3',
        4 => 'h-4 w-4',
        5 => 'h-5 w-5',
        6 => 'h-6 w-6',
        8 => 'h-8 w-8',
        10 => 'h-10 w-10',
        12 => 'h-12 w-12',
        16 => 'h-16 w-16'
      }.freeze

      def classes
        [
          SIZE_CLASSES.fetch(@size),
          @classes
        ].flatten.compact.join(' ')
      end
    end
  end
end
