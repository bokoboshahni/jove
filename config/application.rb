# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'

Bundler.require(*Rails.groups)

lib_path = File.expand_path('../lib', __dir__)
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

require 'jove/configurable'

module Jove
  class Application < Rails::Application
    initializer 'app_assets', after: 'importmap.assets' do
      Rails.application.config.assets.paths << Rails.root.join('app') # for component sidecar js
    end

    config.load_defaults 7.0

    # ActiveRecord settings
    config.active_record.encryption.primary_key = ENV.fetch('ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY')
    config.active_record.encryption.deterministic_key = ENV.fetch('ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY')
    config.active_record.encryption.key_derivation_salt = ENV.fetch('ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT')
    config.active_record.schema_format = :sql

    # ActiveStorage settiings
    config.active_storage.service = ENV.fetch('ACTIVE_STORAGE_SERVICE', 'local').to_sym

    # I18n settings
    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}')]
    config.i18n.load_path += Dir[Rails.root.join('app/components/**/*.yml')]

    # Importmap settings
    config.importmap.cache_sweepers << Rails.root.join('app/components')

    # ViewComponent settings
    config.view_component.default_preview_layout = 'component_preview'
    config.view_component.preview_paths << Rails.root.join('app/components')
  end
end
