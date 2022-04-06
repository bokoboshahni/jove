# frozen_string_literal: true

class AdminController < ApplicationController
  include AuthenticatedController
  include AuthorizedController
end
