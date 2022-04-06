# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope if admin?

      scope.none
    end
  end

  def show?
    return true if record_is_self?

    super
  end

  def update?
    return true if record_is_self?

    super
  end

  def confirm_destroy?
    destroy?
  end

  def destroy?
    return true if record_is_self?

    super
  end

  private

  def record_is_self?
    user == record
  end
end
