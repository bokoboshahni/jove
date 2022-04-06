# frozen_string_literal: true

module Jove
  module Form
    module Placeholderable
      def initialize(**)
        super

        tag_value = @system_args[:placeholder]
        return unless tag_value

        placeholder = tag_value if tag_value.is_a?(String)
        method_and_value = tag_value.is_a?(TrueClass) ? @method_name : "#{@method_name}.#{tag_value}"

        placeholder ||= Tags::Translator
                        .new(object, @object_name, method_and_value, scope: 'helpers.placeholder')
                        .translate
        placeholder ||= @method_name.humanize
        @system_args[:placeholder] = placeholder
      end
    end
  end
end
