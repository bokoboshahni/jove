# frozen_string_literal: true

class ApplicationPolicy
  class Scope
    def initialize(identity, scope)
      @identity = identity
      @scope = scope
    end

    def resolve
      admin? ? scope : scope.none
    end

    private

    attr_reader :identity, :scope

    delegate :user, to: :identity, allow_nil: true
    delegate :admin?, to: :user, allow_nil: true
  end

  attr_reader :identity, :record

  delegate :user, to: :identity, allow_nil: true
  delegate :admin?, to: :user, allow_nil: true

  def initialize(identity = nil, record = nil)
    @identity = identity
    @record = record
  end

  def index?
    admin?
  end

  def show?
    admin?
  end

  def create?
    admin?
  end

  def new?
    create?
  end

  def update?
    admin?
  end

  def edit?
    update?
  end

  def confirm_destroy?
    destroy?
  end

  def destroy?
    admin?
  end

  protected

  def record_identity_owner?
    record.identity == identity
  end
end
