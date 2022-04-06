# frozen_string_literal: true

module Jove
  module Form
    module RadioGroup
      class Component < Jove::Form::Base::Component
        renders_many :choices, lambda { |tag_value, **args|
          Jove::Form::RadioGroup::Choice::Component.new(
            tag_value:,
            **args.merge(
              method_name: @method_name,
              object: @object,
              object_name: @object_name
            )
          )
        }

        def initialize(object_name:, object:, method_name:, legend: nil, **system_args)
          super

          builder = ActionView::Helpers::Tags::Label::LabelBuilder.new(self, @object_name, @method_name, @object, nil)
          @legend = legend.present? ? legend : builder.translation
        end

        self.container_class_names = ''
      end
    end
  end
end
