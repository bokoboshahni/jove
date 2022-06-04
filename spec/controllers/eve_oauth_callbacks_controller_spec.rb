# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EVEOAuthCallbacksController, type: :controller do
  describe '#eve' do
    context 'when user is logged in and scopes are empty' do
      let(:character) { create(:character) }
      let(:user) { create(:registered_user) }

      before { sign_in(user) }

      shared_context 'permitted character' do
        before { create(:login_permit, permittable: character) }
      end

      shared_context 'stub authentication from SSO' do
        let(:auth) do
          OmniAuth::AuthHash.new(provider: 'eve', uid: character.id).tap do |auth|
            auth.info = { scopes: '' }
          end
        end

        before do
          request.env['devise.mappings'] = Devise.mappings[:user]
          request.env['omniauth.auth'] = auth
        end
      end

      shared_examples 'failed authentication' do
        it 'sets the failure flash' do
          expect(controller).to set_flash[:failure]
        end

        it 'redirects to the character settings page' do
          expect(response).to redirect_to(settings_identities_path)
        end
      end

      context 'with an unregistered character that is valid for login' do
        include_context 'permitted character'
        include_context 'stub authentication from SSO'

        before { post :eve }

        it 'sets the success flash' do
          expect(controller).to set_flash[:success]
        end

        it 'adds a new identity to the current user for the character' do
          expect(user.identities.find_by(character_id: character.id)).to be_persisted
        end

        it 'redirects to the character settings page' do
          expect(response).to redirect_to(settings_identities_path)
        end
      end

      context 'with an unregistered character that is not valid for login' do
        include_context 'stub authentication from SSO'

        before { post :eve }

        include_examples 'failed authentication'
      end

      context 'with a registered character' do
        include_context 'permitted character'
        include_context 'stub authentication from SSO'

        before do
          create(:identity, user:, character:)
          post :eve
        end

        include_examples 'failed authentication'
      end
    end

    context 'when user is logged in and scopes are not empty' do
      let(:user) { create(:registered_user) }

      before { sign_in(user) }

      shared_context 'stub authorization from SSO' do
        let(:access_token) { SecureRandom.hex(32) }
        let(:refresh_token) { SecureRandom.hex(32) }
        let(:expires_at) { 1.hour.from_now.to_i }
        let(:scopes) { token.scopes }
        let(:token) { create(:esi_token, :approved, identity: user.default_identity) }
        let(:token_id) { token.id }
        let(:uid) { token.identity.character_id }

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

        before do
          request.session[:authorizing_token_id] = token_id
          request.env['devise.mappings'] = Devise.mappings[:user]
          request.env['omniauth.auth'] = auth
        end
      end

      shared_examples 'failed authorization' do
        it 'sets the failure flash' do
          expect(controller).to set_flash[:failure]
        end

        it 'does not authorize the token' do
          expect(token.reload).not_to be_authorized
        end

        it 'redirects to the ESI settings page' do
          expect(response).to redirect_to(settings_esi_tokens_path)
        end

        it 'clears the authorizing token from the session' do
          expect(session[:authorizing_token_id]).to be_nil
        end
      end

      context 'when the authorization matches the authorizing token' do
        include_context 'stub authorization from SSO'

        before { post :eve }

        it 'sets the success flash' do
          expect(controller).to set_flash[:success]
        end

        it 'authorizes the token' do
          expect(token.reload).to be_authorized
        end

        it 'clears the authorizing token from the session' do
          expect(session[:authorizing_token_id]).to be_nil
        end

        it 'redirects to the ESI settings page' do
          expect(response).to redirect_to(settings_esi_tokens_path)
        end
      end

      context 'when the character in the authorization does not match the authorizing token' do
        include_context 'stub authorization from SSO'

        let(:uid) { Faker::Number.within(range: 90_000_000..98_000_000) }

        before { post :eve }

        include_examples 'failed authorization'
      end

      context 'when the scopes in the authorization do not match the authorizing token' do
        include_context 'stub authorization from SSO'

        let(:scopes) { %w[esi-characters.read_standings.v1] }

        before { post :eve }

        include_examples 'failed authorization'
      end
    end

    context 'when user is logged out' do
      shared_context 'permitted character' do
        let(:character) { create(:character, :with_login_permit) }
      end

      shared_context 'registered user' do
        let(:character) { user.characters.first }
        let(:user) { create(:registered_user) }
      end

      shared_context 'stub authentication from SSO' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'eve', uid: character.id) }

        before do
          request.env['devise.mappings'] = Devise.mappings[:user]
          request.env['omniauth.auth'] = auth
        end
      end

      shared_examples 'successful authentication' do
        it 'sets the success flash' do
          expect(controller).to set_flash[:success]
        end

        it 'logs in the user' do
          expect(warden).to be_authenticated(:user)
        end

        it 'redirects to the dashboard' do
          expect(response).to redirect_to(dashboard_root_path)
        end
      end

      shared_examples 'failed authentication' do
        it 'sets the failure flash' do
          expect(controller).to set_flash[:failure]
        end

        it 'does not log in the user' do
          expect(warden).not_to be_authenticated(:user)
        end

        it 'redirects to the homepage' do
          expect(response).to redirect_to(root_path)
        end
      end

      context 'with a registered user and identity that is valid for login' do
        include_context 'registered user'
        include_context 'stub authentication from SSO'

        before { post :eve }

        include_examples 'successful authentication'
      end

      context 'with a registered user and identity that is no longer valid for login' do
        include_context 'registered user'
        include_context 'stub authentication from SSO'

        before do
          LoginPermit.destroy_all
          post :eve
        end

        include_examples 'failed authentication'
      end

      context 'with an unregistered user and character that is valid for login' do
        include_context 'permitted character'
        include_context 'stub authentication from SSO'

        before { post :eve }

        include_examples 'successful authentication'
      end

      context 'with an unregistered user and character that is not valid for login' do
        include_context 'stub authentication from SSO'

        let(:character) { create(:character) }

        before { post :eve }

        include_examples 'failed authentication'
      end
    end
  end
end
