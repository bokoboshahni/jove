# frozen_string_literal: true

module MarketsFeatureController
  extend ActiveSupport::Concern

  included do
    before_action :ensure_markets_enabled
  end

  def ensure_markets_enabled
    raise ActionController::RoutingError, 'Not Found' unless Flipper.enabled?(:markets)
  end
end
