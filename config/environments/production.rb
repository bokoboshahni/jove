# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # General Rails settings
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # ActionController settings
  config.action_controller.perform_caching = true

  # Asset pipeline configuration
  config.assets.compile = false

  # ActionMailer settings
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true

  # I18n settings
  config.i18n.fallbacks = true

  # ActiveSupport settings
  config.active_support.report_deprecations = false

  # Logging settings
  config.log_formatter = ::Logger::Formatter.new
  config.log_level = :info
  config.log_tags = [:request_id]

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # ActiveRecord settings
  config.active_record.dump_schema_after_migration = false
end
