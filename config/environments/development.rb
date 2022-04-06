# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do # rubocop:disable Metrics/BlockLength
  # General Rails settings
  config.cache_classes = false
  config.consider_all_requests_local = true
  config.eager_load = false
  config.server_timing = true

  # Cache settings
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # ActiveStorage settings
  config.active_storage.service = :local

  # ActionMailer settings
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = false

  # ActiveSupport settings
  config.active_support.deprecation = :raise
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []

  # ActiveRecord settings
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true

  # Asset pipeline settings
  config.assets.quiet = true

  # I18n settings
  config.i18n.raise_on_missing_translations = true

  # Lookbook settings
  config.lookbook.project_name = 'Jove Design System'
end
