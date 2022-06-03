# frozen_string_literal: true

module Admin
  class ESIGrantsController < AdminController
    include TabularController

    self.sort_columns = {
      'name' => 'grant_type',
      'character' => 'characters.name',
      'status' => 'status'
    }.freeze

    self.sort_name_param = 'grant_type'

    before_action :find_grant, only: %i[confirm_destroy destroy]
    before_action :ensure_frame_response, only: %i[new confirm_destroy]

    def index
      scope = ESIGrant.includes(identity: :character).order(sort_param).page(page_param).per(per_page_param)
      @esi_grants = authorize(policy_scope(scope))
    end

    def new
      @esi_grant = authorize(ESIGrant.new)
    end

    def create
      @esi_grant = authorize(ESIGrant.new(grant_param))
      @esi_grant.requester = current_identity

      if @esi_grant.save
        flash[:success] = t('.success', type: @esi_grant.model_name.human, name: @esi_grant.identity.name)
        redirect_to admin_esi_grants_path
      else
        render 'new', status: :unprocessable_entity
      end
    end

    def confirm_destroy; end

    def destroy
      if @grant.revoke!
        flash[:success] = t('.success')
      else
        flash[:failure] = t('.failure')
      end

      redirect_to(admin_esi_tokens_path)
    end

    private

    def find_grant
      @grant = authorize(Grant.find(params[:id] || params[:grant_id]))
    end

    helper_method :grant_class
    def grant_class
      "ESIGrant::#{params[:grant_type].classify}"
    end

    def grant_param
      params.require(:esi_grant).permit(:identity_id, :grant_type, :grantable_id, :grantable_type)
    end
  end
end
