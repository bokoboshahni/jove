# frozen_string_literal: true

module Admin
  class MarketLocationsController < AdminController
    include MarketsFeatureController

    before_action :find_market
    before_action :find_location, only: %i[confirm_destroy destroy]

    def new
      @location = authorize(@market.locations.build(location_type:))
    end

    def create # rubocop:disable Metrics/AbcSize
      @location = authorize(@market.locations.create(location_param))
      if @location.persisted?
        flash[:success] = t('.success', market: @market.name, name: @location.name)
        redirect_to admin_market_path(@market)
      else
        flash[:failure] = t('.failure', market: @market.name, name: @location.name)
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      if @location.destroy
        flash[:success] = t('.success', market: @market.name, name: @location.name)
      else
        flash[:failure] = t('.failure', market: @market.name, name: @location.name)
      end

      redirect_to admin_market_path(@market)
    end

    def autocomplete_stations
      authorize :market_location, :autocomplete?
      @results = StationService.find(7).stations.search_by_name(params[:q])
      render partial: 'autocompletions/results'
    end

    def autocomplete_structures
      authorize :market_location, :autocomplete?
      @results = Structure.search_by_name(params[:q])
      render partial: 'autocompletions/results'
    end

    private

    LOCATION_TYPES = %w[Station Structure].freeze

    helper_method :autocomplete_url
    def autocomplete_url
      case location_type
      when 'Station'
        autocomplete_stations_admin_market_locations_path
      when 'Structure'
        autocomplete_structures_admin_market_locations_path
      end
    end

    def location_param
      params.require(:market_location).permit(:location_type, :location_id)
    end

    def location_type
      LOCATION_TYPES.find { |t| t == params[:location_type] }
    end

    def find_market
      @market = Market.friendly.find(params[:market_id])
    end

    def find_location
      @location = authorize(@market.locations.find_by!(location_id: params[:id] || params[:location_id]))
    end
  end
end
