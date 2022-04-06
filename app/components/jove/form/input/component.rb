# frozen_string_literal: true

module Jove
  module Form
    module Input
      class Component < Jove::Form::Base::Component
        include Placeholderable

        def initialize(**system_args)
          super

          @label_classes = @system_args.delete(:label_classes)
          @input_classes = @system_args.delete(:input_classes)

          @help = @system_args.delete(:help)
          @error = @system_args.delete(:error)
          @error ||= object.errors.messages_for(@method_name) if object.errors.messages_for(@method_name).any?
          @hint = @system_args.delete(:hint)

          @leading_icon = @system_args.delete(:leading_icon)
          @trailing_icon = @error ? ERROR_ICON : @system_args.delete(:trailing_icon)
        end

        private

        class_attribute :field_type
        self.field_type = 'text'

        def input_options
          @input_options ||=
            begin
              opts = @system_args.stringify_keys
              opts['size'] = opts['maxlength'] unless opts.key?('size')
              opts['type'] ||= field_type
              opts['value'] = opts.fetch('value') { value_before_type_cast }
              opts['class'] = input_classes
              add_default_name_and_id(opts)
              opts
            end
        end

        self.container_class_names = 'relative mt-1 ' \
                                     'border-none rounded-sm ' \
                                     'bg-surface-variant ' \
                                     'text-label-lg text-on-surface-variant ' \

        ERROR_ICON = 'heroicons/solid/exclamation-circle'

        INPUT_CLASSES = 'block w-full mt-1 ' \
                        'border-none rounded-sm shadow-elevation-1 ' \
                        'bg-surface-variant ' \
                        'text-label-lg text-on-surface-variant ' \

        INPUT_COLOR_CLASSES = {
          default: 'focus:border-on-surface-variant focus:ring-on-surface-variant',
          error: 'focus:border-danger focus:ring-danger'
        }.freeze

        LABEL_CLASSES = 'block text-label-lg'

        LABEL_COLOR_CLASSES = {
          default: 'text-on-surface',
          error: 'text-danger'
        }.freeze

        LEADING_ICON_WRAPPER_CLASSES = 'absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none'

        TRAILING_ICON_WRAPPER_CLASSES = 'absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none'

        ICON_COLOR_CLASSES = {
          default: 'text-on-surface-variant',
          error: 'text-danger'
        }.freeze

        def input_classes
          join_classes(
            INPUT_CLASSES,
            INPUT_COLOR_CLASSES[color_selector],
            input_padding_classes,
            @input_classes
          )
        end

        def input_padding_classes
          class_names = []
          class_names << 'pl-10' if @leading_icon
          class_names << 'pr-10' if @trailing_icon
          class_names
        end

        def label_options
          { label: @label, object:, object_name: @object_name, method_name: @method_name, class: label_classes,
            **@system_args }
        end

        def label_classes
          join_classes(LABEL_CLASSES, LABEL_COLOR_CLASSES[color_selector], @label_classes)
        end

        def leading_icon_wrapper_classes
          join_classes(LEADING_ICON_WRAPPER_CLASSES)
        end

        def trailing_icon_wrapper_classes
          join_classes(TRAILING_ICON_WRAPPER_CLASSES)
        end

        def icon_color_classes
          join_classes(ICON_COLOR_CLASSES[color_selector])
        end

        def color_selector
          object.errors.include?(@method_name) || @error ? :error : :default
        end
      end
    end
  end
end
