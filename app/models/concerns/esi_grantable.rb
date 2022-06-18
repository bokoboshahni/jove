# frozen_string_literal: true

module ESIGrantable
  extend ActiveSupport::Concern

  included do
    has_many :esi_tokens, as: :resource
  end

  def with_esi_token(grant_type, &)
    token = esi_tokens.authorized_by_type(grant_type).first
    return false unless token

    token.with_token(&)
  end

  def esi_authorized?(grant_type)
    esi_tokens.authorized_by_type(grant_type).any?
  end
end
