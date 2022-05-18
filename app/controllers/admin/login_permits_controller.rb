# frozen_string_literal: true

module Admin
  class LoginPermitsController < AdminController
    include TabularController

    before_action :find_login_permit, only: %i[confirm_destroy destroy]
    before_action :ensure_frame_response, only: %i[new]

    def index
      @login_permits = authorize(policy_scope(LoginPermit.order(:name)))
    end

    def new
      @login_permit = authorize(LoginPermit.new(permittable_type: 'Character'))
    end

    def create
      @login_permit = authorize(LoginPermit.new(login_permit_params))

      if @login_permit.save
        flash[:success] = t('.success', type: @login_permit.permittable_type, name: @login_permit.name)
        redirect_to admin_login_permits_path, status: :see_other
      else
        render 'new', status: :unprocessable_entity
      end
    end

    def confirm_destroy; end

    def destroy
      @login_permit.destroy
      flash[:success] = t('.success', name: @login_permit.name)
      redirect_to admin_login_permits_path
    end

    private

    def find_login_permit
      @login_permit = authorize(LoginPermit.find(params[:id] || params[:login_permit_id]))
    end

    def login_permit_params
      params.require(:login_permit).permit(:permittable_id, :permittable_type)
    end
  end
end
