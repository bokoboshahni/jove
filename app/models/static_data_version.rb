# frozen_string_literal: true

require 'down/http'
require 'json/add/exception'

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
class StaticDataVersion < ApplicationRecord # rubocop:disable Metrics/ClassLength
  include AASM
  include Auditable

  class Error < StandardError; end

  class EmptyChecksumError < Error; end

  class UnzipError < Error; end

  class UnzipNotInstalledError < Error; end

  kredis_list :status_log_lines

  enum :status, %i[
    pending
    downloading
    downloaded
    downloading_failed
    importing
    imported
    importing_failed
  ].index_with(&:to_s)

  has_one_attached :archive

  aasm column: :status, enum: true, timestamps: true, whiny_persistence: true do # rubocop:disable Metrics/BlockLength
    state :pending, initial: true
    state :downloading, :downloaded, :downloading_failed
    state :importing, :imported, :importing_failed

    event :download do
      transitions from: :pending, to: :downloading

      before { reset_status_log }

      after_commit :download_archive
    end

    event :finish_download do
      transitions from: :downloading, to: :downloaded

      before do
        self.status_exception = nil
        self.status_log = status_log_lines.elements
      end
    end

    event :fail_download do
      transitions from: :downloading, to: :downloading_failed

      before { |exception| update!(status_exception: exception, status_log: status_log_lines.elements) }
    end

    event :import do
      transitions from: %i[downloaded importing_failed], to: :importing

      before { reset_status_log }

      after_commit :import_archive
    end

    event :finish_import do
      transitions from: :importing, to: :imported

      before do
        self.status_exception = nil
        self.status_log = status_log_lines.elements
      end
    end

    event :fail_import do
      transitions from: :importing, to: :importing_failed

      before do |exception|
        update!(status_exception: exception, status_log: status_log_lines.elements)
      end
    end
  end

  def self.check_for_new_version!
    checksum = Retriable.retriable(on: EmptyChecksumError) do
      result = Typhoeus.get(Jove.config.sde_checksum_url).body.strip
      raise EmptyChecksumError if result.blank?

      result
    end

    return if StaticDataVersion.exists?(checksum:)

    StaticDataVersion.create!(checksum:)
  end

  def latest?
    self == self.class.order(:created_at).last
  end

  def downloadable?
    (pending? || downloading_failed?) && latest?
  end

  def importable?
    downloaded? || importing_failed?
  end

  private

  ARCHIVE_MIME_TYPE = 'application/zip'

  def download_archive
    Retriable.retriable(download_retry_opts) do
      file = Down::Http.download(Jove.config.sde_archive_url)
      archive.attach(io: file, filename: archive_filename, content_type: ARCHIVE_MIME_TYPE)
      finish_download!
    end
  rescue StandardError => e
    fail_download!(e)
  end

  def import_archive
    check_requirements
    import_models
    update_current
    finish_import!
  rescue StandardError => e
    fail_import!(e)
  end

  def check_requirements
    result = cmd.run!('which unzip')
    result.each { |l| add_status_log(l) }

    raise UnzipNotInstalledError if result.failure?
  end

  def import_models
    archive.open do |file|
      Dir.chdir(File.dirname(file.path)) do
        sde_path = File.join(File.dirname(file.path), 'sde')
        FileUtils.rm_rf(sde_path)
        unzip_archive(file.path)
        run_importers(sde_path)
      end
    end
  end

  def unzip_archive(path)
    result = cmd.run!('unzip -qq', path, only_output_on_error: true)
    result.each { |l| add_status_log(l) }

    raise UnzipError if result.failure?
  end

  def run_importers(sde_path) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    Logidze.with_responsible(id) do
      max_mem = GetProcessMem.new.mb
      Jove::SDE::Importers.all.each do |importer_class|
        mem_before = GetProcessMem.new.mb
        importer = importer_class.new(sde_path:, logger: Rails.logger, threads: Rails.env.test? ? 0 : 2)
        importer.import_all
        mem_after = GetProcessMem.new.mb
        max_mem = mem_after if mem_after > max_mem
        add_status_log(
          "Imported #{importer_class.sde_model.name} - " \
          "Memory: #{mem_after.round - mem_before.round}MB"
        )
      ensure
        GC.start
      end
    ensure
      add_status_log("Max memory: #{max_mem}MB")
    end
  end

  def update_current
    transaction do
      StaticDataVersion.find_by(current: true)&.update!(current: nil)
      update!(current: true, imported_at: Time.zone.now)
    end
  end

  def add_status_log(msg)
    status_log_lines.append(msg)
  end

  def reset_status_log
    status_log_lines.clear
  end

  def run(*args, **kwargs)
    result = cmd.run!(*args, **kwargs.merge(err: :out))
    result.each { |l| add_status_log(l) }
  end

  def cmd
    @cmd ||= TTY::Command.new(output: Rails.logger)
  end

  def archive_filename
    "sde-#{checksum}.zip"
  end

  def download_retry_opts
    Jove.config.sde_download_retry_options
  end
end
