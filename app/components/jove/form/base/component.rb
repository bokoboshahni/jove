# frozen_string_literal: true

module Jove
  module Form
    module Base
      class Component < Jove::Component
        include FormOptionsHelper

        def initialize(object:, object_name:, method_name:, **system_args)
          super

          @system_args.except!(:object, :object_name, :method_name)

          @object_name = object_name.to_s.dup
          @method_name = method_name.to_s.dup
          @object_name.sub!(/\[\]$/, '') || @object_name.sub!(/\[\]\]$/, ']')
          @object = object
          @skip_default_ids = @system_args.delete(:skip_default_ids)
          @allow_method_names_outside_object = @system_args.delete(:allow_method_names_outside_object)
          @label = @system_args.delete(:label)
        end

        def call
          raise NotImplementedError, 'Subclasses must implement a call method'
        end

        private

        attr_reader :object

        def value
          if @allow_method_names_outside_object
            object.public_send @method_name if object.respond_to?(@method_name)
          elsif object
            object.public_send @method_name
          end
        end

        def value_before_type_cast
          return if object.nil?

          method_before_type_cast = "#{@method_name}_before_type_cast"

          if value_came_from_user? && object.respond_to?(method_before_type_cast)
            object.public_send(method_before_type_cast)
          else
            value
          end
        end

        def value_came_from_user?
          method_name = "#{@method_name}_came_from_user?"
          !object.respond_to?(method_name) || object.public_send(method_name)
        end

        def retrieve_autoindex(_pre_match)
          if object.respond_to?(:to_param)
            object.to_param
          else
            raise ArgumentError, "object[] naming but object param and @object var don't " \
                                 "exist or don't respond to to_param: #{object.inspect}"
          end
        end

        def add_default_name_and_id_for_value(tag_value, options)
          if tag_value.nil?
            add_default_name_and_id(options)
          else
            specified_id = options['id']
            add_default_name_and_id(options)

            options['id'] += "_#{sanitized_value(tag_value)}" if specified_id.blank? && options['id'].present?
          end
        end

        def add_default_name_and_id(options)
          index = name_and_id_index(options)
          options['name'] = options.fetch('name') { tag_name(multiple: options['multiple'], index:) }

          return unless generate_ids?

          options['id'] = options.fetch('id') { tag_id(index:, namespace: options.delete('namespace')) }
          namespace = options.delete('namespace')
          options['id'] = (options['id'] ? "#{namespace}_#{options['id']}" : namespace) if namespace
        end

        def tag_name(multiple: false, index: nil)
          field_name(@object_name, sanitized_method_name, multiple:, index:)
        end

        def tag_id(index: nil, namespace: nil)
          field_id(@object_name, @method_name, index:, namespace:)
        end

        def sanitized_method_name
          @sanitized_method_name ||= @method_name.delete_suffix('?')
        end

        def sanitized_value(value)
          value.to_s.gsub(/[\s.]/, '_').gsub(/[^-[[:word:]]]/, '').downcase
        end

        def placeholder_required?(html_options)
          # See https://html.spec.whatwg.org/multipage/forms.html#attr-select-required
          html_options['required'] && !html_options['multiple'] && html_options.fetch('size', 1).to_i == 1
        end

        def add_options(option_tags, options, value = nil) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
          if options[:include_blank]
            content = (options[:include_blank] if options[:include_blank].is_a?(String))
            label = (' ' unless content)
            content_tag_string = tag_builder.content_tag_string('option', content, value: '', label:)
            option_tags = "#{content_tag_string}\n#{option_tags}"
          end

          if value.blank? && options[:prompt]
            tag_options = { value: '' }.tap do |prompt_opts|
              prompt_opts[:disabled] = true if options[:disabled] == ''
              prompt_opts[:selected] = true if options[:selected] == ''
            end
            content_tag_string = tag_builder.content_tag_string('option', prompt_text(options[:prompt]), tag_options)
            option_tags = "#{content_tag_string}\n#{option_tags}"
          end

          option_tags
        end

        def name_and_id_index(options)
          if options.key?('index')
            options.delete('index') || ''
          elsif @generate_indexed_names
            @auto_index || ''
          end
        end

        def generate_ids?
          !@skip_default_ids
        end
      end
    end
  end
end
