# frozen_string_literal: true

module Jove
  module Masthead
    class Component < Jove::Component
      renders_one :branding

      renders_many :items, Jove::Masthead::Item::Component

      renders_one :avatar
      renders_one :menu

      renders_one :banner, Jove::Banner::Component

      def initialize(avatar:)
        super

        @avatar = avatar
      end
    end
  end
end
