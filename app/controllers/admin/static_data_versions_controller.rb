# frozen_string_literal: true

module Admin
  class StaticDataVersionsController < AdminController
    include TabularController

    before_action :find_version, only: %i[show confirm_download download confirm_import import]

    def index
      scope = StaticDataVersion.order(sort_param).page(page_param).per(per_page_param)
      @versions = policy_scope(scope)
    end

    def check
      authorize(:static_data_version, :check?)

      if StaticDataVersion.check_for_new_version!
        flash[:success] = t('.success.new_version')
      else
        flash[:primary] = t('.success.no_new_version')
      end

      redirect_to admin_static_data_versions_path
    end

    def confirm_download
      redirect_to(admin_static_data_versions_path) unless @version.downloadable?
    end

    def download
      if @version.downloadable?
        DownloadStaticDataVersionJob.perform_async(@version.id)
        flash[:success] = t('.success', version: @version.id)
      else
        flash[:failure] = t('.failure', version: @version.id)
      end

      redirect_to admin_static_data_versions_path
    end

    def confirm_import
      redirect_to(admin_static_data_versions_path) unless @version.importable?
    end

    def import # rubocop:disable Metrics/AbcSize
      if @version.importable?
        ImportStaticDataVersionJob.perform_async(@version.id)
        flash[:success] = t('.success', version: @version.id)
      elsif @version.imported?
        flash[:failure] = t('.failure.already_imported', version: @version.id)
      elsif !@version.downloaded?
        flash[:failure] = t('.failure.not_downloaded', version: @version.id)
      end

      redirect_to admin_static_data_versions_path
    end

    private

    self.sort_columns = {
      'checksum' => 'checksum',
      'downloaded_at' => 'downloaded_at',
      'imported_at' => 'imported_at',
      'status' => 'status'
    }.freeze

    self.sort_name_param = 'checksum'

    def find_version
      @version = authorize(StaticDataVersion.find(id_param))
    end

    def id_param
      params.fetch(:id, params.fetch(:static_data_version_id))
    end
  end
end
