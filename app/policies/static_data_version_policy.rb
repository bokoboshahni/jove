# frozen_string_literal: true

class StaticDataVersionPolicy < ApplicationPolicy
  class Scope < Scope
  end

  def check?
    admin?
  end

  def download?
    admin?
  end

  def import?
    admin?
  end
end
