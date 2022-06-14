# frozen_string_literal: true

module Admin
  module MarketsHelper
    MARKET_STATUS_COLOR = {
      pending: :secondary,
      aggregating: :notice,
      aggregated: :success,
      aggregating_failed: :danger,
      disabled: :neutral
    }.freeze

    def market_status_color(market)
      MARKET_STATUS_COLOR.fetch(market.status.to_sym)
    end
  end
end
