# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern

  include PgSearch::Model
end
