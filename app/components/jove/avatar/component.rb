# frozen_string_literal: true

module Jove
  module Avatar
    class Component < Jove::Component
      def initialize(src:, size: 6, **system_args)
        super

        @src = src
        @size = size
      end

      def call
        image_tag(@src, class: classes, **@system_args)
      end

      private

      self.class_names = 'rounded-full'

      SIZE_CLASSES = {
        3 => 'h-3 w-3',
        4 => 'h-4 w-4',
        5 => 'h-5 w-5',
        6 => 'h-6 w-6',
        8 => 'h-8 w-8',
        10 => 'h-10 w-10',
        12 => 'h-12 w-12',
        16 => 'h-16 w-16',
        24 => 'h-24 w-24'
      }.freeze

      def classes
        join_classes(
          super,
          SIZE_CLASSES.fetch(@size)
        )
      end
    end
  end
end
