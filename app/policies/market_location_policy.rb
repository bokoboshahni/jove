# frozen_string_literal: true

class MarketLocationPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def autocomplete?
    admin?
  end
end
