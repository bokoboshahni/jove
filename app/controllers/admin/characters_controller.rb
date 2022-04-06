# frozen_string_literal: true

module Admin
  class CharactersController < AdminController
    include TabularController

    def index
      scope = Character
              .includes(:alliance, :corporation, identity: :last_successful_login)
              .order(sort_param)
              .page(page_param).per(per_page_param)
      @characters = policy_scope(scope)
    end

    self.sort_columns = {
      'name' => 'name',
      'corporation' => 'corporations.name',
      'alliance' => 'alliances.name',
      'created' => 'created_at',
      'updated' => 'esi_last_modified_at',
      'last_login' => 'identities.created_at'
    }.freeze
  end
end
