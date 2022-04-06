# frozen_string_literal: true

module Admin
  class CorporationsController < AdminController
    include TabularController

    def index
      scope = Corporation
              .includes(:alliance)
              .order(sort_param)
              .page(page_param).per(per_page_param)
      @corporations = policy_scope(scope)
    end

    self.sort_columns = {
      'name' => 'name',
      'ticker' => 'ticker',
      'alliance' => 'alliances.name'
    }.freeze
  end
end
