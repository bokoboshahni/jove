# frozen_string_literal: true

class ESIGrantPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope if admin?

      scope.includes(:token).where('esi_tokens.identity_id' => user.identity_ids)
    end
  end

  def index?
    true
  end

  def new?
    create?
  end

  def create?
    admin?
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

  def destroy?
    record.identity == identity || admin?
  end
end
