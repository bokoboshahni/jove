# frozen_string_literal: true

class MarketOrderSourcePolicy < ApplicationPolicy
  class Scope < Scope
  end

  def confirm_enable?
    enable?
  end

  def enable?
    admin?
  end

  def confirm_disable?
    disable?
  end

  def disable?
    admin?
  end

  def confirm_disable_all?
    disable_all?
  end

  def disable_all?
    admin?
  end

  def autocomplete_regions?
    admin?
  end

  def autocomplete_structures?
    admin?
  end
end
