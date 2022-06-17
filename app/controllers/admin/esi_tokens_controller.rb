# frozen_string_literal: true

module Admin
  class ESITokensController < AdminController
    include TabularController

    before_action :find_token, only: %i[confirm_destroy destroy]
    before_action :ensure_frame_response, only: %i[new confirm_destroy]

    def index
      scope = ESIToken.includes(identity: :character)
                      .order(sort_param)
                      .page(page_param).per(per_page_param)
      @tokens = authorize(policy_scope(scope))
    end

    def new
      @token = authorize(ESIToken.new(grant_type:))
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
      token
    end

    def find_token
      @token = authorize(ESIToken.find(params[:id] || params[:esi_token_id]))
    end

    def grant_type
      type = ESIToken::GRANT_TYPES.keys.find { |t| t == params[:grant_type].to_sym }
      raise ActiveRecord::RecordNotFound unless type

      type
    end

    def token_param
      params.require(:esi_token).permit(:grant_type, :identity_id, :resource_type, :resource_id)
    end
  end
end
