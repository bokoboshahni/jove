# frozen_string_literal: true

class EVEOAuthCallbacksController < ApplicationController
  skip_before_action :store_user_location!, only: :eve
  skip_before_action :verify_authenticity_token, only: :eve

  def eve
    if auth_for_identity?
      add_identity
    elsif auth_for_esi?
      authorize_esi
    else
      authenticate_user
    end
  end

  private

  def add_identity # rubocop:disable Metrics/AbcSize
    identity = current_user.create_identity_from_sso!(auth)
    if identity.persisted?
      # i18n-tasks-use t('eve_oauth_callbacks.add_identity.success')
      flash[:success] = t('.add_identity.success', name: identity.name)
    else
      # i18n-tasks-use t('eve_oauth_callbacks.add_identity.failure')
      Rails.logger.info(identity.errors.inspect)
      flash[:failure] = t('.add_identity.failure', name: identity.name)
    end

    redirect_to settings_identities_path
  end

  def authenticate_user # rubocop:disable Metrics/AbcSize
    user_session = UserSession.from_sso!(auth)
    if user_session.valid?
      session[:current_identity_id] = user_session.identity.id
      flash[:success] = t('.authenticate_user.success', name: user_session.identity.name)
      sign_in_and_redirect(user_session.user, event: :authentication)
    else
      # i18n-tasks-use t('eve_oauth_callbacks.authenticate_user.failure')
      flash[:failure] = t('.authenticate_user.failure')
      redirect_to root_path
    end
  end

  def authorize_esi
    token = ESIToken.find(session[:authorizing_token_id])
    token.authorize!(auth)
    flash[:success] = t('.authorize_esi.success', name: token.name)
  rescue AASM::InvalidTransition
    flash[:failure] = t('.authorize_esi.failure')
  ensure
    session[:authorizing_token_id] = nil
    redirect_to settings_esi_tokens_path
  end

  def auth
    request.env['omniauth.auth']
  end

  def auth_scopes
    auth.info.scopes
  end

  def auth_for_identity?
    user_signed_in? && auth_scopes.blank?
  end

  def auth_for_esi?
    user_signed_in? && auth_scopes.present?
  end
end
