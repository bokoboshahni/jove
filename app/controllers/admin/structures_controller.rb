# frozen_string_literal: true

module Admin
  class StructuresController < AdminController
    include TabularController

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
  end
end
