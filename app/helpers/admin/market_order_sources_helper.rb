# frozen_string_literal: true

module Admin
  module MarketOrderSourcesHelper
    MARKET_ORDER_SOURCE_STATUS_COLOR = {
      pending: :secondary,
      fetching: :notice,
      fetched: :success,
      fetching_failed: :danger,
      disabled: :neutral
    }.freeze

    def market_order_source_status_color(source)
      MARKET_ORDER_SOURCE_STATUS_COLOR.fetch(source.status.to_sym)
    end
  end
end
