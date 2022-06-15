# frozen_string_literal: true

module Admin
  class MarketOrderSourcesController < AdminController
    include TabularController

    before_action :find_source, only: %i[show confirm_enable enable confirm_disable disable confirm_destroy destroy]

    def index
      scope = MarketOrderSource
              .includes(:source)
              .order(sort_param)
              .page(page_param).per(per_page_param)
      @sources = policy_scope(scope)
    end

    def enable
      if @source.enable!
        flash[:success] = t('.success', name: @source.name)
      else
        flash[:failure] = t('.failure', name: @source.name)
      end

      redirect_to admin_market_order_source_path(@source)
    end

    def disable
      if @source.disable!
        flash[:success] = t('.success', name: @source.name)
      else
        flash[:failure] = t('.failure', name: @source.name)
      end

      redirect_to admin_market_order_source_path(@source)
    end

    def disable_all
      if MarketOrderSource.disable_all!
        flash[:success] = t('.success')
      else
        flash[:failure] = t('.failure')
      end

      redirect_to admin_markets_path
    end

    private

    self.sort_columns = {
      'name' => 'name',
      'status' => 'status',
      'fetched' => 'fetched_at',
      'expires' => 'expires_at'
    }.freeze

    def find_source
      @source = authorize(MarketOrderSource.find(params[:id] || params[:market_order_source_id]))
    end
  end
end
