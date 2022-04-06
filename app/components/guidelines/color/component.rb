# frozen_string_literal: true

module Guidelines
  module Color
    class Component < ApplicationComponent
      renders_many :colors, lambda { |color:, label: nil|
        size_classes = SIZE_CLASSES.fetch(@size)

        style = "background-color: rgb(var(--jove-color-#{color}))"
        content_tag(:div, class: "#{color} #{size_classes} relative", style:) do
          content_tag(:div, label, class: 'absolute top-0 left-0 p-2 text-sm font-medium')
        end
      }

      def initialize(size: :sm)
        super

        @size = size
      end

      SIZE_CLASSES = {
        sm: 'h-10 w-10',
        lg: 'h-32 w-32'
      }.freeze
    end
  end
end
