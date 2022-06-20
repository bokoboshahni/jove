# frozen_string_literal: true

module Admin
  class FeaturesController < AdminController
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped

    def enable # rubocop:disable Metrics/AbcSize
      if Flipper.enabled?(feature_name)
        flash[:failure] = t('.failure', name: feature_name.to_s.humanize)
      else
        Flipper.enable(feature_name)
        flash[:success] = t('.success', name: feature_name.to_s.humanize)
      end

      redirect_to admin_features_path
    end

    def disable # rubocop:disable Metrics/AbcSize
      if Flipper.enabled?(feature_name)
        Flipper.disable(feature_name)
        flash[:success] = t('.success', name: feature_name.to_s.humanize)
      else
        flash[:failure] = t('.failure', name: feature_name.to_s.humanize)
      end

      redirect_to admin_features_path
    end

    private

    FEATURES = %i[markets].freeze

    helper_method :feature_name
    def feature_name
      FEATURES.find { |f| f == params[:feature_id].to_sym }
    end
  end
end
