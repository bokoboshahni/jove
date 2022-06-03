# frozen_string_literal: true

class AutocompletePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def identities?
    admin?
  end
end
