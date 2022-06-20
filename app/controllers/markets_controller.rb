# frozen_string_literal: true

class MarketsController < ApplicationController
  include AuthenticatedController
  include AuthorizedController
  include MarketsFeatureController
end
