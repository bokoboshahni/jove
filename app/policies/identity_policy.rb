# frozen_string_literal: true

class IdentityPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope if admin?

      scope.where(user:)
    end
  end

  def index?
    true
  end

  def show?
    record.user == user || admin?
  end

  def create?
    true
  end

  def update?
    record.user == user || admin?
  end

  def confirm_destroy?
    destroy?
  end

  def destroy?
    record.user == user || admin?
  end

  def change_default?
    record.user == user || admin?
  end

  def switch?
    record.user == user
  end
end
