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
# **`log_data`**               | `jsonb`            |
# **`status`**                 | `enum`             | `not null`
# **`status_exception`**       | `jsonb`            |
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

  class Error < RuntimeError; end

  class UnzipError < Error; end

  class UnzipNotInstalledError < Error; end

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

      after_commit :download_archive
    end

    event :finish_download do
      transitions from: :downloading, to: :downloaded

      before { self.status_exception = nil }
    end

    event :fail_download do
      transitions from: :downloading, to: :downloading_failed

      before { |exception| update!(status_exception: exception) }
    end

    event :import do
      transitions from: %i[downloaded importing_failed], to: :importing

      after_commit :import_archive
    end

    event :finish_import do
      transitions from: :importing, to: :imported

      before { self.status_exception = nil }
    end

    event :fail_import do
      transitions from: :importing, to: :importing_failed

      before { |exception| update!(status_exception: exception) }
    end
  end

  def self.check_for_new_version!
    checksum = Typhoeus.get(Jove.config.sde_checksum_url).body.strip

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
    raise UnzipNotInstalledError if cmd.run!('which unzip').failure?
  end

  def import_models # rubocop:disable Metrics/AbcSize
    archive.open do |file|
      Dir.chdir(File.dirname(file.path)) do
        raise UnzipError if cmd.run!('unzip', file.path).failure?

        Logidze.with_responsible(id) do
          sde_path = File.join(File.dirname(file.path), 'sde')
          Jove::SDE::Importers.all.each { |i| i.new(sde_path:).import_all }
        end
      end
    end
  end

  def update_current
    transaction do
      StaticDataVersion.find_by(current: true)&.update!(current: nil)
      update!(current: true, imported_at: Time.zone.now)
    end
  end

  def cmd
    @cmd ||= TTY::Command.new
  end

  def archive_filename
    "sde-#{checksum}.zip"
  end

  def download_retry_opts
    Jove.config.sde_download_retry_options
  end
end
