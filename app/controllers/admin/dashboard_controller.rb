# frozen_string_literal: true

module Admin
  class DashboardController < AdminController
    def show
      authorize :admin, :show?
    end
  end
end
