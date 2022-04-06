# frozen_string_literal: true

module Jove
  module Form
    module Label
      class Component < Jove::Form::Base::Component
        def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          opts = @system_args.stringify_keys
          tag_value = opts.delete('value')
          name_and_id = opts.dup

          if name_and_id['for']
            name_and_id['id'] = name_and_id['for']
          else
            name_and_id.delete('id')
          end

          add_default_name_and_id_for_value(tag_value, name_and_id)
          opts.except!('index', 'namespace', 'tag_value', 'label')
          opts['for'] = name_and_id['id'] unless opts.key?('for')
          opts['class'] = classes if classes.present?

          builder = ActionView::Helpers::Tags::Label::LabelBuilder.new(self, @object_name, @method_name, @object,
                                                                       tag_value)

          label_content = @label
          label_content ||= content.present? ? content : builder.translation
          label_tag(name_and_id['id'], label_content, opts)
        end
      end
    end
  end
end
