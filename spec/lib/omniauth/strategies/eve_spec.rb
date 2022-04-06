# frozen_string_literal: true

require 'rails_helper'
require 'omniauth/strategies/eve'

RSpec.describe OmniAuth::Strategies::Eve, type: :lib do
  let(:metadata) do
    {
      'issuer' => 'login.eveonline.com',
      'authorization_endpoint' => 'https://login.eveonline.com/v2/oauth/authorize',
      'token_endpoint' => 'https://login.eveonline.com/v2/oauth/token',
      'response_types_supported' => %w[code token],
      'jwks_uri' => 'https://login.eveonline.com/oauth/jwks',
      'revocation_endpoint' => 'https://login.eveonline.com/v2/oauth/revoke',
      'revocation_endpoint_auth_methods_supported' => %w[client_secret_basic client_secret_post
                                                         client_secret_jwt],
      'token_endpoint_auth_methods_supported' => %w[client_secret_basic client_secret_post client_secret_jwt],
      'token_endpoint_auth_signing_alg_values_supported' => ['HS256'],
      'code_challenge_methods_supported' => ['S256']
    }
  end

  let(:kid) { 'JWT-Signature-Key' }
  let(:jwk) { JWT::JWK.new(OpenSSL::PKey::RSA.new(2048), kid) }
  let(:jwks) { { 'keys' => [jwk.export] } }

  let(:character_id) { 2_119_309_952 }
  let(:expiration) { Time.now.to_i * 60 * 60 }
  let(:payload) do
    {
      'scp' => ['esi-universe.read_structures.v1', 'esi-markets.structure_markets.v1',
                'esi-contracts.read_corporation_contracts.v1'],
      'jti' => SecureRandom.uuid,
      'kid' => kid,
      'sub' => 'CHARACTER:EVE:2119309952',
      'azp' => SecureRandom.uuid,
      'tenant' => 'tranquility',
      'tier' => 'live',
      'region' => 'world',
      'aud' => 'EVE Online',
      'name' => 'Lady Arek',
      'owner' => 'Ma9i5qN00NjfdDXxQZMp25m3Zb4=',
      'exp' => expiration,
      'iat' => expiration,
      'iss' => 'login.eveonline.com'
    }
  end

  let(:jwt) { JWT.encode(payload, jwk.keypair, 'RS256', 'kid' => kid) }

  let(:access_token) { instance_double('AccessToken', options: {}, :[] => 'user') }
  subject(:strategy) { described_class.new({}) }

  around do |example|
    VCR.turn_off!
    WebMock.disable_net_connect!
    example.run
    WebMock.allow_net_connect!
    VCR.turn_on!
  end

  before do
    allow(strategy).to receive(:access_token).and_return(access_token)
    allow(access_token).to receive(:token).and_return(jwt)

    stub_request(:get, 'https://login.eveonline.com/.well-known/oauth-authorization-server')
      .to_return(body: metadata.to_json)

    stub_request(:get, 'https://login.eveonline.com/oauth/jwks')
      .to_return(body: jwks.to_json)
  end

  describe '#options' do
    it 'has the correct site' do
      expect(strategy.options.client_options.site).to eq('https://login.eveonline.com')
    end

    it 'has the correct authorize URL' do
      expect(strategy.options.client_options.authorize_url).to eq('/v2/oauth/authorize')
    end

    it 'has the correct token URL' do
      expect(strategy.options.client_options.token_url).to eq('/v2/oauth/token')
    end
  end

  describe '#uid' do
    it 'uses the character ID' do
      expect(strategy.uid).to eq(character_id)
    end
  end

  describe '#info' do
    it 'includes the character name' do
      expect(strategy.info[:name]).to eq(payload['name'])
    end

    it 'includes the character ID' do
      expect(strategy.info[:character_id]).to eq(character_id)
    end

    it 'includes the expiration' do
      expect(strategy.info[:expires_at]).to eq(Time.at(expiration).to_datetime)
    end

    it 'includes the scopes' do
      expect(strategy.info[:scopes]).to eq(payload['scp'])
    end

    it 'includes the token type' do
      expect(strategy.info[:token_type]).to eq(:character)
    end

    it 'includes the owner hash' do
      expect(strategy.info[:owner]).to eq(payload['owner'])
    end
  end

  describe '#extra' do
    it 'includes the decoded JWT' do
      expect(strategy.extra[:data]).to eq(payload)
    end
  end
end
