# frozen_string_literal: true

module Jove
  module Header
    class Component < Jove::Component
      renders_one :avatar, lambda { |src:|
                             Jove::Avatar::Component.new(src:, size: 12)
                           }

      renders_one :title
      renders_one :description

      renders_many :actions
    end
  end
end
