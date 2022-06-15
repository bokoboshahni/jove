# frozen_string_literal: true

module Admin
  class ESITokensController < AdminController
    include TabularController

    before_action :find_token, only: %i[confirm_destroy destroy]
    before_action :ensure_frame_response, only: %i[new confirm_destroy]

    def index
      scope = ESIToken.includes(:grants, identity: :character)
                      .order(sort_param)
                      .page(page_param).per(per_page_param)
      @tokens = authorize(policy_scope(scope))
    end

    def new
      @token = authorize(ESIToken.new)
      @token.scopes = grant_type.requested_scopes
      @token.grants.build(type: grant_type.name)
    end

    def create
      @token = authorize(build_token)

      if @token.save
        flash[:success] = t('.success', name: @token.name)
        redirect_to admin_esi_tokens_path
      else
        render 'new', status: :unprocessable_entity
      end
    end

    def confirm_destroy; end

    def destroy
      if @token.destroy
        flash[:success] = t('.success', name: @token.name)
      else
        flash[:failure] = t('.failure', name: @token.name)
      end

      redirect_to admin_esi_tokens_path
    end

    private

    self.sort_columns = {
      'name' => 'characters.name',
      'status' => 'status'
    }.freeze

    self.sort_name_param = 'characters.name'

    def build_token
      token = authorize(ESIToken.new(token_param))
      token.requester = current_identity
      token.scopes = token.grants.first.requested_scopes
      token.grants.each do |grant|
        grant.requester = current_identity
      end
      token
    end

    def find_token
      @token = authorize(ESIToken.find(params[:id] || params[:esi_token_id]))
    end

    def grant_type
      grant_class = ESIGrant::GRANT_TYPES.find { |c| c.name == "ESIGrant::#{params[:grant_type].classify}" }
      raise ActiveRecord::RecordNotFound unless grant_class

      grant_class
    end

    def token_param
      params.require(:esi_token).permit(:identity_id, grants_attributes: %i[type grantable_type grantable_id])
    end
  end
end
