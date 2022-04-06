# frozen_string_literal: true

module Jove
  module TurboDialog
    class Component < Jove::Component
      include Turbo::FramesHelper

      renders_many :actions

      def initialize(title:, icon: nil, dismissable: false)
        super

        @title = title
        @icon = icon
        @dismissable = dismissable
      end
    end
  end
end
