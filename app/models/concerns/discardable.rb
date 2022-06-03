# frozen_string_literal: true

module Discardable
  extend ActiveSupport::Concern

  include Discard::Model
end
