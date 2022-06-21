# frozen_string_literal: true

module Admin
  class MarketsController < AdminController
    include MarketsFeatureController
    include TabularController

    before_action :find_market, except: %i[index new create]

    def index
      scope = Market
              .includes(:locations, :sources)
              .order(sort_param)
              .page(page_param).per(per_page_param)
      @markets = policy_scope(scope)
    end

    def new
      @market = authorize(Market.new)
      @market.locations.build
      @market.market_sources.build
    end

    def create
      @market = authorize(Market.create(market_param))
      if @market.persisted?
        flash[:success] = t('.success', name: @market.name)
        redirect_to admin_market_path(@market)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @market.update(market_param)
        flash[:success] = t('.success', name: @market.name)
        redirect_to admin_market_path(@market)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def enable
      if @market.enable!
        flash[:success] = t('.success', name: @market.name)
      else
        flash[:failure] = t('.failure', name: @market.name)
      end

      redirect_to admin_market_path(@market)
    end

    def disable
      if @market.disable!
        flash[:success] = t('.success', name: @market.name)
      else
        flash[:failure] = t('.failure', name: @market.name)
      end

      redirect_to admin_market_path(@market)
    end

    def destroy
      if @market.destroy
        flash[:success] = t('.success', name: @market.name)
        redirect_to admin_markets_path
      else
        flash[:failure] = t('.failure', name: @market.name)
        redirect_to admin_market_path(@market)
      end
    end

    private

    self.sort_columns = {
      'name' => 'name',
      'status' => 'status',
      'created' => 'created_at',
      'updated' => 'updated_at'
    }.freeze

    def market_param
      params.require(:market).permit(:name, :description)
    end

    def find_market
      @market = authorize(Market.friendly.find(params[:id] || params[:market_id]))
    end
  end
end
