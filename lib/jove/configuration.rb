# frozen_string_literal: true

module Jove
  class Configuration
    DEFAULT_USER_AGENT = 'Jove/1.0; (+https://github.com/bokoboshahni/jove)'

    attr_writer :esi_client_id, :esi_client_secret, :site_url, :user_agent

    def admin_character_ids
      @admin_character_ids ||= from_env(:admin_character_ids, '').split(',').map(&:to_i)
    end

    def email_from
      @email_from ||= from_env(:email_from)
    end

    def esi_client_id
      @esi_client_id ||= from_env(:esi_client_id)
    end

    def esi_client_secret
      @esi_client_secret ||= from_env(:esi_client_secret)
    end

    def site_host
      site_uri.host
    end

    def site_port
      site_uri.port
    end

    def site_protocol
      site_uri.scheme
    end

    def site_uri
      @site_uri ||= URI(site_url)
    end

    def site_url
      @site_url ||= from_env(:site_url, default_site_url)
    end

    def user_agent
      @user_agent ||= from_env(:user_agent, DEFAULT_USER_AGENT)
    end

    private

    def from_env(name, default = nil, required: false)
      val = ENV.fetch("JOVE_#{name.upcase}") { default }

      raise RequiredConfigurationMissingError, name if val.blank? && required

      val
    end

    # :nocov:
    def default_site_url
      case Rails.env
      when 'development'
        'http://localhost:3000'
      when 'test'
        'http://test.host'
      when 'production' && ENV.fetch('ASSETS_PRECOMPILE', nil)
        'http://assets.host'
      end
    end
    # :nocov:
  end
end
