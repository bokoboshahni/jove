# frozen_string_literal: true

module Settings
  class ESIGrantsController < SettingsController
    before_action :find_grant
    before_action :ensure_frame_response, only: %i[confirm_approve confirm_reject confirm_destroy]

    def approve
      if @grant.approve!
        flash[:success] = t('.success')
      else
        flash[:failure] = t('.failure')
      end

      redirect_to(settings_esi_tokens_path)
    end

    def reject
      if @grant.reject!
        flash[:success] = t('.success')
      else
        flash[:failure] = t('.failure')
      end

      redirect_to(settings_esi_tokens_path)
    end

    def destroy
      if @grant.revoke!
        flash[:success] = t('.success')
      else
        flash[:failure] = t('.failure')
      end
    end

    private

    def find_grant
      @grant = authorize(ESIGrant.find(params[:id] || params[:esi_grant_id]))
    end
  end
end
