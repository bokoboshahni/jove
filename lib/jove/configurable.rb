# frozen_string_literal: true

module Jove
  module Configurable
    extend ActiveSupport::Concern

    def jove
      Jove.config
    end
  end
end
