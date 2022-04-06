# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    user_signed_in? ? redirect_to(dashboard_root_path) : render(:index)
  end
end
