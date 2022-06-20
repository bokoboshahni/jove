# frozen_string_literal: true

module Admin
  class MarketSourcesController < AdminController
    include MarketsFeatureController

    before_action :find_market
    before_action :find_source, only: %i[confirm_destroy destroy]

    def new
      @source = authorize(@market.market_sources.build)
    end

    def create # rubocop:disable Metrics/AbcSize
      @source = authorize(@market.market_sources.create(source_param))
      if @source.persisted?
        flash[:success] = t('.success', market: @market.name, name: @source.name)
        redirect_to admin_market_path(@market)
      else
        flash[:failure] = t('.failure', market: @market.name, name: @source.name)
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if @source.destroy
        flash[:success] = t('.success', market: @market.name, name: @source.name)
      else
        flash[:failure] = t('.failure', market: @market.name, name: @source.name)
      end

      redirect_to admin_market_path(@market)
    end

    def autocomplete_regions
      @results = authorize(MarketOrderSource.regions.search_by_name(params[:q]))
      render partial: 'autocompletions/results'
    end

    def autocomplete_structures
      @results = authorize(MarketOrderSource.structures.search_by_name(params[:q]))
      render partial: 'autocompletions/results'
    end

    private

    SOURCE_TYPES = %w[Region Structure].freeze

    helper_method :autocomplete_url
    def autocomplete_url
      case source_type
      when 'Region'
        autocomplete_regions_admin_market_sources_path
      when 'Structure'
        autocomplete_structures_admin_market_sources_path
      end
    end

    def source_param
      params.require(:market_source).permit(:source_id)
    end

    def source_type
      SOURCE_TYPES.find { |t| t == params[:source_type] }
    end

    def find_market
      @market = Market.friendly.find(params[:market_id])
    end

    def find_source
      @source = authorize(@market.market_sources.find_by!(
                            source_id: params[:id] || params[:source_id]
                          ))
    end
  end
end
