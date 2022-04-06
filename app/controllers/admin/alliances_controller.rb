# frozen_string_literal: true

module Admin
  class AlliancesController < AdminController
    include TabularController

    def index
      scope = Alliance
              .order(sort_param)
              .page(page_param).per(per_page_param)
      @alliances = policy_scope(scope)
    end

    self.sort_columns = {
      'name' => 'name',
      'ticker' => 'ticker'
    }.freeze
  end
end
