# frozen_string_literal: true

require 'omniauth/strategies/eve'

OmniAuth.config.logger = Rails.logger

Devise.setup do |config|
  require 'devise/orm/active_record'

  config.timeout_in = 24.hours

  config.omniauth :eve, Jove.config.esi_client_id, Jove.config.esi_client_secret
end
