# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EVEOAuthCallbacksController, type: :controller do
  describe '#eve' do
    context 'when user is logged in' do
      let(:character) { create(:character) }
      let(:user) { create(:registered_user) }

      before { sign_in(user) }

      shared_context 'permitted character' do
        before { create(:login_permit, permittable: character) }
      end

      shared_context 'stub authentication from SSO' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'eve', uid: character.id) }

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
