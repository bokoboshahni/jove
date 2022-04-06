# frozen_string_literal: true

module Admin
  class UsersController < AdminController
    include TabularController

    def index
      scope = User.includes(
        :default_alliance, :default_corporation, :login_activities,
        default_identity: :character
      )
                  .order(sort_param)
                  .page(page_param).per(per_page_param)
      @users = policy_scope(scope)
    end

    def confirm_destroy
      @user = authorize(User.find(params[:user_id]))
    end

    def destroy # rubocop:disable Metrics/AbcSize
      user = authorize(User.find(params[:id]))
      user.destroyer = current_user
      name = user.name.dup
      if user.destroy
        flash[:success] = t('.success', name:)
      else
        flash[:failure] = t('.failure', name:)
      end

      redirect_to admin_users_path
    end

    self.sort_columns = {
      'name' => 'characters.name',
      'corporation' => 'corporations.name',
      'alliance' => 'alliances.name'
    }.freeze

    self.sort_name_param = 'characters.name'
  end
end
