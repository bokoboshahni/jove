# frozen_string_literal: true

require 'active_support/concern'

module Jove
  module Configurable
    extend ActiveSupport::Concern

    def jove
      Jove.config
    end
  end
end
