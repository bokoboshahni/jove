# frozen_string_literal: true

require 'action_view/helpers/tags/checkable'

module Jove
  module Form
    module RadioGroup
      module Choice
        class Component < Jove::Form::Base::Component
          include ActionView::ModelNaming
          include ActionView::Helpers::Tags::Checkable

          def initialize(label:, tag_value:, description: nil, **system_args)
            super

            @label = label
            @description = description
            @tag_value = tag_value
          end

          private

          LABEL_CLASSES = 'block text-label-lg text-on-surface'

          DESCRIPTION_CLASSES = 'block text-label-md text-on-surface-variant'

          def checked?(value)
            value.to_s == @tag_value.to_s
          end

          def radio_button_options
            options = @system_args.stringify_keys
            options['value'] = @tag_value
            options['checked'] = 'checked' if input_checked?(options)
            add_default_name_and_id_for_value(@tag_value, options)
            options
          end

          def button_classes; end

          def label_options
            { object:, object_name: @object_name, method_name: @method_name, class: label_classes, value: @tag_value,
              **@system_args }
          end

          def label_classes
            join_classes(LABEL_CLASSES)
          end

          def description_classes
            join_classes(DESCRIPTION_CLASSES)
          end
        end
      end
    end
  end
end
