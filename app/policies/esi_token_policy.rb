# frozen_string_literal: true

class ESITokenPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope if admin?

      scope.where(identity: user.identity_ids)
    end
  end

  def index?
    true
  end

  def new
    create?
  end

  def create
    admin?
  end

  def create?
    true
  end

  def confirm_approve?
    approve?
  end

  def approve?
    record_identity_owner?
  end

  def confirm_reject?
    reject?
  end

  def reject?
    record_identity_owner?
  end

  def confirm_destroy?
    destroy?
  end

  def authorize_token?
    record_identity_owner?
  end

  def destroy?
    record_identity_owner? || admin?
  end
end
