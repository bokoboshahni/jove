# frozen_string_literal: true

require 'json'
require 'jwt'
require 'net/http'
require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Eve < OmniAuth::Strategies::OAuth2
      option :name, 'eve'

      option :client_options,
             authorize_url: '/v2/oauth/authorize',
             token_url: '/v2/oauth/token',
             site: 'https://login.eveonline.com'

      uid { character_id }

      info do
        {
          name: data['name'],
          character_id:,
          expires_at: Time.at(data['exp']).to_datetime,
          scopes: data['scp'],
          token_type: data['sub'].split(':')[0].downcase.to_sym,
          owner: data['owner']
        }
      end

      extra { { data: } }

      def jwt # rubocop:disable Metrics/MethodLength
        @jwt ||= begin
          JWT.decode(
            access_token.token, nil, true,
            algorithm: 'RS256',
            jwks:,
            verify_aud: true, aud: 'EVE Online',
            verify_iss: true, iss: metadata['issuer']
          )
        rescue OpenSSL::PKey::PKeyError => e
          raise unless e.message =~ /incompatible with OpenSSL 3\.0/

          # FIXME: Hack for https://github.com/ruby/openssl/issues/369
          JWT.decode(access_token.token, nil, false)
        end
      end

      def character_id
        data['sub'].split(':')[-1].to_i
      end

      def data
        jwt.find { |e| e.key?('jti') }
      end

      def jwks
        @jwks ||= JSON.parse(http.get(metadata['jwks_uri']).body)
      end

      def metadata
        @metadata ||= JSON.parse(http.get('/.well-known/oauth-authorization-server').body)
      end

      def http
        @http ||= begin
          uri = URI.parse('https://login.eveonline.com')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http
        end
      end
    end
  end
end
