# frozen_string_literal: true

class AutocompletionsController < ApplicationController
  include AuthenticatedController
  include AuthorizedController

  def identities
    authorize :autocomplete, :identities?
    @results = Identity.search_by_name(params[:q])
    render partial: 'results'
  end
end
