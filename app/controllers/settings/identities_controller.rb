# frozen_string_literal: true

module Settings
  class IdentitiesController < SettingsController
    before_action :find_identity, only: %i[confirm_destroy destroy change_default switch]

    def index
      authorize :identity, :index?
      @identities = policy_scope(current_user.identities.includes(:character, :corporation,
                                                                  :alliance).order('characters.name' => :asc))
    end

    def create
      authorize :identity, :create?
      state = session['omniauth.state'] = SecureRandom.hex(24)
      redirect_to(oauth.auth_code.authorize_url(redirect_uri: esi_redirect_uri, state:), allow_other_host: true)
    end

    def destroy
      if @identity.destroy
        flash[:success] = t('.success', name: @identity.name)
      else
        flash[:failure] = t('.failure', name: @identity.name)
      end

      redirect_to(settings_identities_path)
    end

    def change_default # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      name = @identity.name
      if @identity.default?
        flash[:failure] = t('.failure.already_default', name:)
      elsif @identity.valid_for_login?
        if current_user.change_default_identity!(@identity)
          flash[:success] = t('.success', name:)
        else
          flash[:error] = t('.error', name:)
        end
      else
        flash[:failure] = t('.failure.invalid_for_login', name:)
      end

      redirect_to(settings_identities_path)
    end

    def switch
      if @identity.valid_for_login?
        session[:current_identity_id] = @identity.id
      else
        flash[:failure] = t('.failure', name: @identity.name)
      end

      redirect_to(after_sign_in_path_for(:user))
    end

    private

    OAUTH_URL = 'https://login.eveonline.com'
    AUTHORIZE_URL = 'v2/oauth/authorize'

    delegate :esi_client_id, :esi_client_secret, to: :jove

    def id_param
      params[:id] || params[:identity_id]
    end

    def find_identity
      @identity = authorize(current_user.identities.find(id_param))
    end

    def esi_redirect_uri
      user_eve_omniauth_callback_url
    end

    def oauth
      @oauth = OAuth2::Client.new(esi_client_id, esi_client_secret, site: OAUTH_URL, authorize_url: AUTHORIZE_URL)
    end
  end
end
