# frozen_string_literal: true

class SettingsPolicy < ApplicationPolicy
  class Scope < Scope
  end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    true
  end

  def create?
    true
  end

  def update?
    true
  end

  def destroy?
    true
  end
end
