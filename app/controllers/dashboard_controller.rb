# frozen_string_literal: true

class DashboardController < ApplicationController
  include AuthenticatedController
  include AuthorizedController
end
