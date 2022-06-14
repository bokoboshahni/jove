# frozen_string_literal: true

class MarketPolicy < ApplicationPolicy
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
end
