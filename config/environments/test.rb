# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # General Rails settings
  config.cache_classes = true
  config.eager_load = ENV['CI'].present?
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }
  config.consider_all_requests_local = true

  # Caching settings
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # ActionDispatch settings
  config.action_dispatch.show_exceptions = false

  # ActionController settings
  config.action_controller.allow_forgery_protection = false

  # ActiveStorage settings
  config.active_storage.service = :test

  # ActionMailer settings
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :test

  # ActiveSupport settings
  config.active_support.deprecation = :stderr
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []

  # I18n settings
  config.i18n.raise_on_missing_translations = true
end

Rails.application.routes.default_url_options = { host: 'test.host' }
