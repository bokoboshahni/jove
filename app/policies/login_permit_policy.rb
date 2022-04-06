# frozen_string_literal: true

class LoginPermitPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope if admin?

      scope.none
    end
  end
end
