# frozen_string_literal: true

host = Jove.configuration.site_host
protocol = Jove.configuration.site_protocol
port = Jove.configuration.site_port
url_options = { host:, port:, protocol: }

Rails.application.default_url_options = url_options
Rails.application.config.action_controller.default_url_options = url_options
Rails.application.config.action_mailer.default_url_options = url_options
