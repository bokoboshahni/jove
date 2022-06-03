# frozen_string_literal: true

require 'jove/esi/scopes'

module Settings
  class ESITokensController < SettingsController
    include TabularController

    before_action :find_token, except: %i[index]
    before_action :ensure_frame_response, only: %i[confirm_approve confirm_reject confirm_destroy]

    def index
      active_tokens = ESIToken.active.includes(identity: :character)
                              .order(sort_param)
                              .page(page_param).per(per_page_param)
      @active_tokens = policy_scope(active_tokens)

      pending_tokens = ESIToken.requested.includes(identity: :character)
      @pending_tokens = policy_scope(pending_tokens)

      approved_tokens = ESIToken.approved.includes(identity: :character)
      @approved_tokens = policy_scope(approved_tokens)
    end

    def approve
      if @token.approve!
        redirect_post(settings_esi_token_authorize_path(@token), options: { authenticity_token: :auto })
      else
        flash[:failure] = t('.failure')
        redirect_to(settings_esi_tokens_path)
      end
    end

    def reject
      if @token.reject!
        flash[:success] = t('.success')
      else
        flash[:failure] = t('.failure')
      end

      redirect_to(settings_esi_tokens_path)
    end

    def authorize_token
      state = session['omniauth.state'] = SecureRandom.hex
      session['authorizing_token_id'] = @token.id
      redirect_to(@token.authorize_url(user_eve_omniauth_callback_url, state), allow_other_host: true)
    end

    def destroy
      if @token.revoke!
        flash[:success] = t('.success')
      else
        flash[:failure] = t('.failure')
      end

      redirect_to(settings_esi_tokens_path)
    end

    private

    self.sort_columns = {
      'name' => 'characters.name'
    }.freeze

    self.sort_name_param = 'characters.name'

    def find_token
      @token = authorize(ESIToken.find(params[:id] || params[:esi_token_id]))
    end
  end
end
