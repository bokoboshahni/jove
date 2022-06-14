# frozen_string_literal: true

module ESIGrantable
  extend ActiveSupport::Concern

  included do
    has_many :esi_grants, as: :grantable
  end

  def with_esi_token(grant_type, &)
    grant = esi_grants.approved_by_type(grant_type).first
    return false unless grant

    grant.with_token(&)
  end

  def esi_authorized?(grant_type)
    esi_grants.authorized_by_type(grant_type).any?
  end
end
