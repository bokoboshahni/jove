# frozen_string_literal: true

module Jove
  module Form
    module TextField
      class Component < Jove::Form::Input::Component
        class_attribute :field_type
        self.field_type = 'text'
      end
    end
  end
end
