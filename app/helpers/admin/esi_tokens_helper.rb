# frozen_string_literal: true

module Admin
  module ESITokensHelper
    ESI_TOKEN_STATUS_COLORS = {
      requested: :secondary,
      approved: :tertiary,
      rejected: :danger,
      authorized: :success,
      expired: :notice,
      revoked: :danger
    }.freeze

    def esi_token_status_color(token)
      ESI_TOKEN_STATUS_COLORS.fetch(token.status.to_sym)
    end
  end
end
