# frozen_string_literal: true

module Dashboard
  class OverviewController < DashboardController
    def show
      authorize :dashboard, :show?
    end
  end
end
