# frozen_string_literal: true

module Admin
  module ESIGrantsHelper
    ESI_GRANT_STATUS_COLORS = {
      requested: :secondary,
      approved: :tertiary,
      rejected: :danger,
      authorized: :success,
      expired: :notice,
      revoked: :danger
    }.freeze

    def esi_grant_status_color(grant)
      ESI_GRANT_STATUS_COLORS.fetch(grant.status.to_sym)
    end
  end
end
