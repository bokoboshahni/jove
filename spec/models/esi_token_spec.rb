# frozen_string_literal: true

# ## Schema Information
#
# Table name: `esi_tokens`
#
# ### Columns
#
# Name                             | Type               | Attributes
# -------------------------------- | ------------------ | ---------------------------
# **`id`**                         | `bigint`           | `not null, primary key`
# **`access_token`**               | `text`             |
# **`approved_at`**                | `datetime`         |
# **`authorized_at`**              | `datetime`         |
# **`expired_at`**                 | `datetime`         |
# **`expires_at`**                 | `datetime`         |
# **`grant_type`**                 | `text`             |
# **`refresh_error_code`**         | `text`             |
# **`refresh_error_description`**  | `text`             |
# **`refresh_error_status`**       | `integer`          |
# **`refresh_token`**              | `text`             |
# **`refreshed_at`**               | `datetime`         |
# **`rejected_at`**                | `datetime`         |
# **`resource_type`**              | `string`           |
# **`revoked_at`**                 | `datetime`         |
# **`scopes`**                     | `text`             | `not null, is an Array`
# **`status`**                     | `enum`             | `not null`
# **`used_at`**                    | `datetime`         |
# **`created_at`**                 | `datetime`         | `not null`
# **`updated_at`**                 | `datetime`         | `not null`
# **`identity_id`**                | `bigint`           | `not null`
# **`requester_id`**               | `bigint`           | `not null`
# **`resource_id`**                | `bigint`           |
#
# ### Indexes
#
# * `index_esi_tokens_on_identity_id`:
#     * **`identity_id`**
# * `index_esi_tokens_on_requester_id`:
#     * **`requester_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`identity_id => identities.id`**
# * `fk_rails_...`:
#     * **`requester_id => identities.id`**
#
require 'rails_helper'

RSpec.describe ESIToken, type: :model do
  let(:time) { Time.zone.now.change(usec: 0) }

  around { |e| travel_to(time) { e.run } }

  describe '.available?' do
    it 'returns true when there are any authorized' do
      token = create(:esi_token, :authorized)
      expect(described_class.available?(token.grant_type)).to be_truthy
    end

    it 'returns false when there are no authorized' do
      token = create(:esi_token)
      expect(described_class.available?(token.grant_type)).to be_falsey
    end
  end

  describe '.unavailable?' do
    it 'returns true when there are no authorized' do
      token = create(:esi_token)
      expect(described_class.unavailable?(token.grant_type)).to be_truthy
    end

    it 'returns false when there are any authorized' do
      token = create(:esi_token, :authorized)
      expect(described_class.unavailable?(token.grant_type)).to be_falsey
    end
  end

  describe '.pending_available?' do
    it 'returns true when there are no approved and any requests' do
      token = create(:esi_token)
      expect(described_class.pending_available?(token.grant_type)).to be_truthy
    end

    it 'returns false when there are no approved and no requests' do
      token = create(:esi_token, :rejected)
      expect(described_class.pending_available?(token.grant_type)).to be_falsey
    end
  end

  describe '.with_token' do
    it 'delegates to #with_token on the first authorized token' do
      token = create(:esi_token, :authorized)
      expect { described_class.with_token(token.grant_type) }.to(change { token.reload.used_at })
    end
  end

  describe '#authorize_url' do
    let(:token) { create(:esi_token) }
    let(:callback_url) { 'http://test.host/auth/eve/callback' }
    let(:state) { SecureRandom.hex(32) }
    let(:query_params) { URI.decode_www_form(URI(authorize_url).query).to_h }

    subject(:authorize_url) { token.authorize_url(callback_url, state) }

    it 'includes the callback URL' do
      expect(query_params['redirect_uri']).to eq(callback_url)
    end

    it 'includes the scopes in the URL' do
      expect(query_params['scope']).to eq(token.scopes.join(' '))
    end

    it 'includes the state in the URL' do
      expect(query_params).to include('state' => state)
    end
  end

  describe '#authorize!' do
    let(:user) { create(:registered_user) }
    let(:identity) { user.default_identity }
    let(:access_token) { SecureRandom.hex(32) }
    let(:refresh_token) { SecureRandom.hex(32) }
    let(:expires_at) { (time + 1.hour).to_i }
    let(:scopes) { token.scopes }
    let(:uid) { identity.character_id }
    let(:auth) do
      OmniAuth::AuthHash.new(provider: 'eve', uid:).tap do |auth|
        auth.credentials = {
          token: access_token,
          refresh_token:,
          expires_at:
        }
        auth.info = { scopes: scopes.join(' ') }
      end
    end

    subject(:token) { create(:esi_token, :approved, identity:) }

    context 'when the authorization matches the token' do
      it 'updates the access token' do
        expect { token.authorize!(auth) }.to(change { token.reload.access_token }.to(access_token))
      end

      it 'updates the refresh token' do
        expect { token.authorize!(auth) }.to(change { token.reload.refresh_token }.to(refresh_token))
      end

      it 'updates the expiry' do
        expect { token.authorize!(auth) }.to(change do
                                               token.reload.expires_at
                                             end.to(Time.zone.at(expires_at).to_datetime))
      end

      it 'updates the refresh time' do
        expect { token.authorize!(auth) }.to(change { token.reload.refreshed_at }.to(Time.zone.now))
      end
    end

    context 'when the authorization does not match the token scopes' do
      let(:scopes) { %w[esi-characters.read_standings.v1] }

      it 'fails to transition the token state' do
        expect { token.authorize!(auth) }.to raise_error(AASM::InvalidTransition)
      end
    end

    context 'when the authorization does not match the token identity' do
      let(:uid) { Faker::Number.within(range: 90_000_000..98_000_000)  }

      it 'fails to transition the token state' do
        expect { token.authorize!(auth) }.to raise_error(AASM::InvalidTransition)
      end
    end
  end

  describe '#renew!' do
    let(:user) { create(:registered_user) }
    let(:identity) { user.default_identity }
    let(:access_token) { SecureRandom.hex(32) }
    let(:refresh_token) { SecureRandom.hex(32) }
    let(:expires_at) { (time + 1.hour).to_i }
    let(:scopes) { token.scopes }
    let(:uid) { identity.character_id }
    let(:auth) do
      OmniAuth::AuthHash.new(provider: 'eve', uid:).tap do |auth|
        auth.credentials = {
          token: access_token,
          refresh_token:,
          expires_at:
        }
        auth.info = { scopes: scopes.join(' ') }
      end
    end

    subject(:token) { create(:esi_token, :expired, identity:) }

    context 'when the authorization matches the token' do
      it 'updates the access token' do
        expect { token.renew!(auth) }.to(change { token.reload.access_token }.to(access_token))
      end

      it 'updates the refresh token' do
        expect { token.renew!(auth) }.to(change { token.reload.refresh_token }.to(refresh_token))
      end

      it 'updates the expiry' do
        expect { token.renew!(auth) }.to(change { token.reload.expires_at }.to(Time.zone.at(expires_at).to_datetime))
      end

      it 'updates the refresh time' do
        expect { token.renew!(auth) }.to(change { token.reload.refreshed_at }.to(Time.zone.now))
      end
    end

    context 'when the authorization does not match the token scopes' do
      let(:scopes) { %w[esi-characters.read_standings.v1] }

      it 'fails to transition the token state' do
        expect { token.renew!(auth) }.to raise_error(AASM::InvalidTransition)
      end
    end

    context 'when the authorization does not match the token identity' do
      let(:uid) { Faker::Number.within(range: 90_000_000..98_000_000)  }

      it 'fails to transition the token state' do
        expect { token.renew!(auth) }.to raise_error(AASM::InvalidTransition)
      end
    end
  end

  describe '#refresh!' do
    let(:user) { create(:registered_user) }
    let(:identity) { user.default_identity }
    let(:token) { create(:esi_token, :authorized, identity:) }

    context 'when token is not expired' do
      it 'returns true' do
        expect(token.refresh!).to be_truthy
      end
    end

    context 'when refreshing the token is successful' do
      let(:new_access_token) { SecureRandom.hex(32) }
      let(:new_refresh_token) { SecureRandom.hex(32) }
      let(:new_expires_at) { (time + 1.hour).to_i }

      before do
        token.update!(expires_at: 10.minutes.ago)
        stub_request(:post, "#{Jove.config.esi_oauth_url}/v2/oauth/token").to_return(
          status: 201,
          headers: { 'Content-Type': 'application/json' },
          body: {
            access_token: new_access_token,
            refresh_token: new_refresh_token,
            expires_at: new_expires_at
          }.to_json
        )
      end

      it 'returns true' do
        expect(token.refresh!).to be_truthy
      end

      it 'updates the access token' do
        expect { token.refresh! }.to(change { token.reload.access_token }.to(new_access_token))
      end

      it 'updates the refresh token' do
        expect { token.refresh! }.to(change { token.reload.refresh_token }.to(new_refresh_token))
      end

      it 'updates the expiry' do
        expect { token.refresh! }.to(change { token.reload.expires_at }.to(Time.zone.at(new_expires_at).to_datetime))
      end

      it 'updates the refresh time' do
        expect { token.refresh! }.to(change { token.reload.refreshed_at }.to(Time.zone.now))
      end
    end

    context 'when refreshing the token is not successful' do
      let(:error_code) { 'invalid_request' }
      let(:error_description) { 'Invalid request' }
      let(:error_status) { 422 }

      before do
        token.update!(expires_at: 10.minutes.ago)
        stub_request(:post, "#{Jove.config.esi_oauth_url}/v2/oauth/token").to_return(
          status: error_status,
          headers: { 'Content-Type': 'application/json' },
          body: {
            error: error_code,
            error_description:
          }.to_json
        )
      end

      it 'returns false' do
        expect(token.refresh!).to be_falsey
      end

      it 'transitions to the expired state' do
        expect { token.refresh! }.to(change { token.reload.expired? }.to(true))
      end

      it 'clears the existing access token' do
        expect { token.refresh! }.to(change { token.reload.access_token }.to(nil))
      end

      it 'clears the existing refresh token' do
        expect { token.refresh! }.to(change { token.reload.refresh_token }.to(nil))
      end

      it 'clears the existing expiry' do
        expect { token.refresh! }.to(change { token.reload.expires_at }.to(nil))
      end

      it 'updates the token with the error code' do
        expect { token.refresh! }.to(change { token.reload.refresh_error_code }.to(error_code))
      end

      it 'updates the token with the error description' do
        expect { token.refresh! }.to(change { token.reload.refresh_error_description }.to(error_description))
      end

      it 'updates the token with the error status' do
        expect { token.refresh! }.to(change { token.reload.refresh_error_status }.to(error_status))
      end

      it 'updates the refresh time' do
        expect { token.refresh! }.to(change { token.reload.refreshed_at }.to(Time.zone.now))
      end
    end
  end

  describe '#to_oauth_token' do
    it 'returns an OAuth2::AccessToken when authorized' do
      expect(build(:esi_token, :authorized).to_oauth_token).to be_a(OAuth2::AccessToken)
    end

    it 'returns nil when not authorized' do
      expect(build(:esi_token).to_oauth_token).to be_nil
    end
  end

  describe '#with_token' do
    let(:token) { create(:esi_token, :authorized) }

    shared_examples 'preconditions not met' do
      it 'returns false' do
        expect(token.with_token).to be_falsey
      end

      it 'does not yield to the block' do
        expect { |b| token.with_token(&b) }.not_to yield_control
      end
    end

    context 'when refreshing the token is successful' do
      before do
        allow(token).to receive(:refresh!).and_return(true)
      end

      it 'yields the access token from the token' do
        expect { |b| token.with_token(&b) }.to yield_with_args(token.access_token)
      end

      it 'returns true' do
        expect(token.with_token).to be_truthy
      end

      it 'updates the usage timestamp' do
        expect { token.with_token }.to(change { token.reload.used_at }.from(nil))
      end
    end

    context 'when the token is not authorized' do
      before { allow(token).to receive(:authorized?).and_return(false) }

      include_examples 'preconditions not met'
    end

    context 'when the token cannot be refreshed' do
      before { allow(token).to receive(:refresh!).and_return(false) }

      include_examples 'preconditions not met'
    end
  end
end
