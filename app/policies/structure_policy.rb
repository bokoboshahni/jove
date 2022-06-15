# frozen_string_literal: true

class StructurePolicy < ApplicationPolicy
  class Scope < Scope
  end

  def confirm_market_source?
    market_source?
  end

  def market_source?
    admin?
  end
end
