# frozen_string_literal: true

module Jove
  module Form
    class Builder < ActionView::Helpers::FormBuilder
      def check_box_group(method, **system_args, &)
        render_component(method, Jove::Form::CheckBoxGroup::Component, **system_args, &)
      end

      def combo_box(method, **system_args, &)
        render_component(method, Jove::Form::ComboBox::Component, **system_args)
      end

      def text_field(method, **system_args)
        render_component(method, Jove::Form::TextField::Component, **system_args)
      end

      def radio_group(method, **system_args, &)
        render_component(method, Jove::Form::RadioGroup::Component, **system_args, &)
      end

      def submit(value = nil, **system_args)
        value ||= submit_default_value
        component = Jove::Button::Component.new(**system_args.merge(value:, label: value))
        @template.render(component)
      end

      private

      def render_component(method, component_class, **args, &)
        component_args = args.merge(object: @object, object_name: @object_name, method_name: method)
        component = component_class.new(**component_args)
        block_given? ? @template.render(component, &) : @template.render(component)
      end

      def submit_default_value # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
        object = convert_to_model(@object)
        key    = if object
                   object.persisted? ? :update : :create
                 else
                   :submit
                 end

        model = if object.respond_to?(:model_name)
                  object.model_name.human
                else
                  @object_name.to_s.humanize
                end

        defaults = []
        # Object is a model and it is not overwritten by as and scope option.
        defaults << if object.respond_to?(:model_name) && object_name.to_s == model.downcase
                      :"helpers.submit.#{object.model_name.i18n_key}.#{key}"
                    else
                      :"helpers.submit.#{object_name}.#{key}"
                    end
        defaults << :"helpers.submit.#{key}"
        defaults << "#{key.to_s.humanize} #{model}"

        I18n.t(defaults.shift, model:, default: defaults)
      end
    end
  end
end
