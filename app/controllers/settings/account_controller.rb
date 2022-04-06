# frozen_string_literal: true

module Settings
  class AccountController < SettingsController
    def show
      authorize :settings, :show?
    end

    def confirm_destroy
      authorize(current_user)
    end

    def destroy
      authorize(current_user)
      if current_user.destroy
        sign_out(current_user)
        flash[:success] = t('.success')
        redirect_to root_path
      else
        flash[:failure] = t('.failure')
        redirect_to settings_account_path
      end
    end
  end
end
