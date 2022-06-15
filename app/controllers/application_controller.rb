# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Jove::Configurable

  before_action :store_user_location!, if: :storable_location?

  impersonates :user

  private

  helper_method :dashboard_controller?
  def dashboard_controller?
    self.class.ancestors.include?(DashboardController)
  end

  helper_method :admin_controller?
  def admin_controller?
    self.class.ancestors.include?(AdminController)
  end

  helper_method :market_controller?
  def market_controller?
    is_a?(MarketsController)
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || dashboard_root_path
  end

  helper_method :current_identity
  def current_identity
    @current_identity ||= Identity.find(current_identity_id)
  end

  def current_identity_id
    session[:current_identity_id] || current_user.default_identity.id
  end

  helper_method :other_identities
  def other_identities
    @other_identities ||= current_user.identities
                                      .includes(:character, :corporation)
                                      .where.not(id: current_identity_id)
                                      .order('characters.name')
  end

  def ensure_frame_response
    return unless Rails.env.development?

    redirect_to(root_path) unless turbo_frame_request?
  end

  def use_logidze_responsible(&)
    Logidze.with_responsible(current_identity&.id, &)
  end
end
