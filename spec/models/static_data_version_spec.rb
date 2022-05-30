# frozen_string_literal: true

# ## Schema Information
#
# Table name: `static_data_versions`
#
# ### Columns
#
# Name                         | Type               | Attributes
# ---------------------------- | ------------------ | ---------------------------
# **`id`**                     | `bigint`           | `not null, primary key`
# **`checksum`**               | `text`             | `not null`
# **`current`**                | `boolean`          |
# **`downloaded_at`**          | `datetime`         |
# **`downloading_at`**         | `datetime`         |
# **`downloading_failed_at`**  | `datetime`         |
# **`imported_at`**            | `datetime`         |
# **`importing_at`**           | `datetime`         |
# **`importing_failed_at`**    | `datetime`         |
# **`log_data`**               | `jsonb`            |
# **`status`**                 | `enum`             | `not null`
# **`status_exception`**       | `jsonb`            |
# **`status_log`**             | `text`             | `is an Array`
# **`created_at`**             | `datetime`         | `not null`
# **`updated_at`**             | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_static_data_versions_on_checksum` (_unique_):
#     * **`checksum`**
# * `index_static_data_versions_on_current` (_unique_):
#     * **`current`**
#
require 'rails_helper'

RSpec.describe StaticDataVersion, type: :model do
  let(:time) { Time.zone.now.change(usec: 0) }

  around { |e| travel_to(time) { e.run } }

  describe '.check_for_new_version!' do
    before do
      stub_request(:get, Jove.config.sde_checksum_url).to_return(body: checksum)
    end

    context 'when there is a new version available' do
      let(:checksum) { SecureRandom.hex(32) }

      it 'creates a new version' do
        expect(described_class.check_for_new_version!.checksum).to eq(checksum)
      end
    end

    context 'when there is no new version available' do
      let(:checksum) { SecureRandom.hex(32) }

      before { StaticDataVersion.create!(checksum:) }

      it 'returns nil' do
        expect(described_class.check_for_new_version!).to be_nil
      end
    end
  end

  describe '#download!' do
    context 'when the download is successful' do
      subject(:version) { create(:static_data_version, :failed) }

      before do
        body = File.new(Rails.root.join('spec/fixtures/sde.zip'))
        stub_request(:get, Jove.config.sde_archive_url).to_return(body:, status: 200)

        version.download!
        version.reload
      end

      it 'transitions to the downloaded state' do
        expect(version).to be_downloaded
      end

      it 'attaches the archive to the version' do
        expect(version.archive).to be_attached
      end

      it 'clears the previous status exception' do
        expect(version.status_exception).to be_nil
      end

      it 'updates the downloaded_at timestamp' do
        expect(version.downloaded_at).to eq(time)
      end
    end

    context 'when the download fails' do
      subject(:version) { create(:static_data_version) }

      before do
        stub_request(:get, Jove.config.sde_archive_url).to_return(status: 500)

        version.download!
        version.reload
      end

      it 'transitions to the downloading_failed state' do
        expect(version).to be_downloading_failed
      end

      it 'serializes the exception' do
        expect(version.status_exception['json_class']).to eq('Down::ServerError')
      end

      it 'updates the downloading_failed_at timestamp' do
        expect(version.downloading_failed_at).to eq(time)
      end
    end
  end

  describe '#downloadable' do
    it 'returns true when pending and latest' do
      create(:static_data_version, created_at: 1.hour.ago)
      latest = create(:static_data_version)

      expect(latest).to be_downloadable
    end

    it 'returns true when downloading failed and latest' do
      create(:static_data_version, created_at: 1.hour.ago)
      latest = create(:static_data_version, status: :downloading_failed)

      expect(latest).to be_downloadable
    end

    it 'returns false when pending but not latest' do
      previous = create(:static_data_version, created_at: 1.hour.ago)
      create(:static_data_version)

      expect(previous).not_to be_downloadable
    end

    it 'returns false when already downloaded' do
      version = create(:static_data_version, :downloaded)
      expect(version).not_to be_downloadable
    end
  end

  describe '#import!' do
    let(:which_unzip_result) { instance_double('TTY::Command::Result') }
    let(:unzip_result) { instance_double('TTY::Command::Result') }

    before do
      command = instance_double('TTY::Command')
      allow(command).to receive(:run!).with('which unzip').and_return(which_unzip_result)
      allow(command).to receive(:run!).with('unzip -qq', anything, any_args).and_return(unzip_result)

      allow(which_unzip_result).to receive(:each)
      allow(unzip_result).to receive(:each)

      command_class = class_double('TTY::Command').as_stubbed_const
      allow(command_class).to receive(:new).and_return(command)
    end

    context 'when importing is successful' do
      subject(:version) { create(:static_data_version, :failed, :downloaded) }

      before do
        create(:static_data_version, :current)

        expect(which_unzip_result).to receive(:failure?).and_return(false)
        expect(unzip_result).to receive(:failure?).and_return(false)

        Jove::SDE::Importers.all.each do |importer_class|
          importer_double = instance_double(importer_class.name)
          expect(importer_double).to receive(:import_all)

          importer_class_double = class_double(importer_class.name).as_stubbed_const
          allow(importer_class_double).to receive(:new).and_return(importer_double)
          allow(importer_class_double).to receive(:sde_model).and_return(importer_class.sde_model)
        end

        version.import!
        version.reload
      end

      it 'clears the previous status exception' do
        expect(version.status_exception).to be_nil
      end

      it 'transitions to the imported state' do
        expect(version).to be_imported
      end

      it 'updates the imported_at timestamp' do
        expect(version.imported_at).to eq(time)
      end

      it 'updates the current version' do
        expect(version).to be_current
      end

      it 'writes the status log to the version' do
        Jove::SDE::Importers.all.each do |importer_class|
          expect(version.status_log.grep(/Imported #{importer_class.sde_model.name}/)).not_to be_empty
        end
      end
    end

    context 'when the unzip command does not exist' do
      subject(:version) { create(:static_data_version, :downloaded) }

      before do
        allow(which_unzip_result).to receive(:failure?).and_return(true)

        version.import!
        version.reload
      end

      it 'transitions to the importing_failed state' do
        expect(version).to be_importing_failed
      end

      it 'updates the status exception of the version' do
        ex = "#{described_class.name}::UnzipNotInstalledError"
        expect(version.status_exception['json_class']).to eq(ex)
      end

      it 'updates the importing_failed_at timestamp' do
        expect(version.importing_failed_at).to eq(time)
      end
    end

    context 'when unzip command fails' do
      subject(:version) { create(:static_data_version, :downloaded) }

      before do
        allow(which_unzip_result).to receive(:failure?).and_return(false)
        allow(unzip_result).to receive(:failure?).and_return(true)

        version.import!
        version.reload
      end

      it 'transitions to the importing_failed state' do
        expect(version).to be_importing_failed
      end

      it 'updates the status exception of the version' do
        ex = "#{described_class.name}::UnzipError"
        expect(version.status_exception['json_class']).to eq(ex)
      end

      it 'updates the importing_failed_at timestamp' do
        expect(version.importing_failed_at).to eq(time)
      end
    end

    context 'when import fails' do
      subject(:version) { create(:static_data_version, :downloaded) }

      before do
        allow(which_unzip_result).to receive(:failure?).and_return(false)
        allow(unzip_result).to receive(:failure?).and_return(false)

        importer_class = Jove::SDE::Importers.all.first

        importer_double = instance_double(importer_class.name)
        expect(importer_double).to receive(:import_all).and_raise(ActiveRecord::ActiveRecordError)

        importer_class_double = class_double(importer_class.name).as_stubbed_const
        expect(importer_class_double).to receive(:new).and_return(importer_double)

        version.import!
        version.reload
      end

      it 'transitions to the importing_failed state' do
        expect(version).to be_importing_failed
      end

      it 'updates the status exception of the version' do
        ex = 'ActiveRecord::ActiveRecordError'
        expect(version.status_exception['json_class']).to eq(ex)
      end

      it 'updates the importing_failed_at timestamp' do
        expect(version.importing_failed_at).to eq(time)
      end
    end
  end

  describe '#importable' do
    it 'returns true when downloaded' do
      version = create(:static_data_version, :downloaded, created_at: 1.hour.ago)
      expect(version).to be_importable
    end

    it 'returns true when importing failed' do
      version = create(:static_data_version, :downloaded, status: :importing_failed, created_at: 1.hour.ago)
      expect(version).to be_importable
    end

    it 'returns false when already imported' do
      version = create(:static_data_version, status: :imported)
      expect(version).not_to be_importable
    end
  end
end
