# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ESITokensController, type: :request do
  let(:admin) { create(:admin_user) }

  before { sign_in(admin) }

  describe 'POST #create' do
    context 'when creating the token is not successful' do
      let(:token) { build(:esi_token, identity: admin.default_identity) }

      before do
        allow(ESIToken).to receive(:new).and_return(token)
        allow(token).to receive(:save).and_return(false)
        post admin_esi_tokens_path(esi_token: { identity_id: admin.default_identity.id })
      end

      it 'responds with an unprocessable entity status' do
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when deleting the token is not successful' do
      let(:token) { build(:esi_token, identity: admin.default_identity) }

      before do
        allow(ESIToken).to receive(:find).and_return(token)
        allow(token).to receive(:destroy).and_return(false)
        delete admin_esi_token_path(1)
      end

      it 'sets the failure flash' do
        expect(flash[:failure]).to be_present
      end

      it 'redirects to the token administration page' do
        expect(response).to redirect_to(admin_esi_tokens_path)
      end
    end
  end
end
