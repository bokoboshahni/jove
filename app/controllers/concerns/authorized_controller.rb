# frozen_string_literal: true

module AuthorizedController
  extend ActiveSupport::Concern

  included do
    include Pundit::Authorization

    after_action :verify_authorized, except: :index
    after_action :verify_policy_scoped, only: :index

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def pundit_user
      current_identity
    end
  end

  private

  def user_not_authorized(_exception)
    flash[:failure] = t('flash.not_authorized')
    redirect_to(request.referrer || root_path)
  end
end
