# frozen_string_literal: true

class StaticDataVersionPolicy < ApplicationPolicy
  class Scope < Scope
  end

  def check?
    admin?
  end

  def confirm_download?
    download?
  end

  def download?
    admin?
  end

  def confirm_import?
    import?
  end

  def import?
    admin?
  end
end
