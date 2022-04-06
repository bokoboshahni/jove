# frozen_string_literal: true

class EVEOAuthCallbacksController < ApplicationController
  skip_before_action :store_user_location!, only: :eve
  skip_before_action :verify_authenticity_token, only: :eve

  def eve
    if user_signed_in?
      add_identity
    else
      authenticate_user
    end
  end

  private

  def add_identity
    identity = current_user.create_identity_from_sso!(auth)
    if identity.persisted?
      # i18n-tasks-use t('eve_oauth_callbacks.add_identity.success')
      flash[:success] = t('.add_identity.success', name: identity.name)
    else
      # i18n-tasks-use t('eve_oauth_callbacks.add_identity.failure')
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

  def auth
    request.env['omniauth.auth']
  end
end
