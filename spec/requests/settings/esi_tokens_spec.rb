# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Settings::ESITokensController, type: :request do
  let(:user) { create(:registered_user) }

  before { sign_in(user) }

  shared_context 'stubbed token' do
    let(:token) { build(:esi_token, identity: user.default_identity) }

    before { allow(ESIToken).to receive(:find).and_return(token) }
  end

  shared_examples 'workflow failure' do
    it 'sets the failure flash' do
      expect(flash[:failure]).to be_present
    end

    it 'redirects to the token settings page' do
      expect(response).to redirect_to(settings_esi_tokens_path)
    end
  end

  describe 'POST #approve' do
    context 'when approving the token is not successful' do
      include_context 'stubbed token'

      before do
        allow(token).to receive(:approve!).and_return(false)
        post settings_esi_token_approve_path(1)
      end

      include_examples 'workflow failure'
    end
  end

  describe 'POST #reject' do
    context 'when rejecting the token is not successful' do
      include_context 'stubbed token'

      before do
        allow(token).to receive(:reject!).and_return(false)
        post settings_esi_token_reject_path(1)
      end

      include_examples 'workflow failure'
    end
  end

  describe 'DELETE #destroy' do
    context 'when revoking the token is not successful' do
      include_context 'stubbed token'

      before do
        allow(token).to receive(:revoke!).and_return(false)
        delete settings_esi_token_path(1)
      end

      include_examples 'workflow failure'
    end
  end
end
