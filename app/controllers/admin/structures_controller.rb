# frozen_string_literal: true

module Admin
  class StructuresController < AdminController
    include TabularController

    before_action :find_structure, except: %i[index new create]

    def index
      scope = Structure
              .includes(:solar_system, corporation: :alliance)
              .order(sort_param)
              .page(page_param).per(per_page_param)
      @structures = policy_scope(scope)
    end

    def new
      @structure = authorize(Structure.new)
    end

    def create
      @structure = authorize(Structure.sync_from_esi!(structure_param[:id]))
      flash[:success] = t('.success', name: @structure.name)
      redirect_to admin_structures_path, status: :see_other
    rescue ActiveRecord::RecordNotFound
      @structure = Structure.new(structure_param)
      @structure.errors.add(:id, :invalid)
      render 'new', status: :unprocessable_entity
    end

    def show; end

    def sync
      Structure.sync_from_esi!(@structure.id)
      flash[:success] = t('.success', name: @structure.name)
    rescue ActiveRecord::RecordNotFound
      flash[:failure] = t('.failure', name: @structure.name)
    ensure
      redirect_to admin_structure_path(@structure)
    end

    def confirm_market_source
      @token = ESIToken.new
    end

    def market_source
      @token = @structure.enable_market_source(current_identity, token_param)
      if @token.persisted?
        flash[:success] = t('.success', name: @structure.name)
      else
        render :confirm_market_source, status: :unprocessable_entity
      end

      redirect_to admin_structure_path(@structure)
    end

    private

    self.sort_columns = {
      'name' => 'name',
      'corporation' => 'corporations.name',
      'alliance' => 'alliances.name',
      'solar_system' => 'solar_systems.name'
    }.freeze

    def structure_param
      params.require(:structure).permit(:id)
    end

    def find_structure
      @structure = authorize(Structure.find(params[:id] || params[:structure_id]))
    end

    def token_param
      params.require(:esi_token).permit(:identity_id)
    end
  end
end
