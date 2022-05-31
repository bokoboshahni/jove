# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::StaticDataVersionsController, type: :request do
  let(:user) { create(:admin_user) }

  before { sign_in(user) }

  describe 'GET /confirm_download' do
    context 'when the version is not downloadable' do
      let(:version) { create(:static_data_version, status: :imported) }

      before { get(admin_static_data_version_confirm_download_path(version)) }

      it 'redirects to the static data versions index' do
        expect(response).to redirect_to(admin_static_data_versions_path)
      end
    end
  end

  describe 'GET /confirm_import' do
    context 'when the version is not importable' do
      let(:version) { create(:static_data_version, status: :imported) }

      before { get(admin_static_data_version_confirm_import_path(version)) }

      it 'redirects to the static data versions index' do
        expect(response).to redirect_to(admin_static_data_versions_path)
      end
    end
  end

  describe 'POST /download' do
    context 'when the version has already been downloaded' do
      let(:version) { create(:static_data_version, status: :downloaded) }
      let(:url) { admin_static_data_version_download_path(version) }

      it 'redirects to the static data versions index' do
        expect(post(url)).to redirect_to(admin_static_data_versions_path)
      end

      it 'does not queue the download job' do
        expect { post(url) }.not_to(
          change(DownloadStaticDataVersionJob.jobs, :size)
        )
      end
    end
  end

  describe 'POST /import' do
    context 'when the version has already been imported' do
      let(:version) { create(:static_data_version, status: :imported) }
      let(:url) { admin_static_data_version_import_path(version) }

      it 'redirects to the static data versions index' do
        expect(post(url)).to redirect_to(admin_static_data_versions_path)
      end

      it 'does not queue the import job' do
        expect { post(url) }.not_to(
          change(ImportStaticDataVersionJob.jobs, :size)
        )
      end
    end
  end
end
