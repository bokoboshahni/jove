# frozen_string_literal: true

# ## Schema Information
#
# Table name: `market_order_sources`
#
# ### Columns
#
# Name                      | Type               | Attributes
# ------------------------- | ------------------ | ---------------------------
# **`id`**                  | `integer`          | `not null, primary key`
# **`disabled_at`**         | `datetime`         |
# **`expires_at`**          | `datetime`         |
# **`fetched_at`**          | `datetime`         |
# **`fetching_at`**         | `datetime`         |
# **`fetching_failed_at`**  | `datetime`         |
# **`name`**                | `text`             | `not null`
# **`pending_at`**          | `datetime`         |
# **`source_type`**         | `string`           | `not null`
# **`status`**              | `enum`             | `not null`
# **`status_exception`**    | `jsonb`            |
# **`created_at`**          | `datetime`         | `not null`
# **`updated_at`**          | `datetime`         | `not null`
# **`source_id`**           | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_unique_market_order_sources` (_unique_):
#     * **`source_type`**
#     * **`source_id`**
#
class MarketOrderSource < ApplicationRecord # rubocop:disable Metrics/ClassLength
  include AASM
  include Searchable

  kredis_unique_list :etags, limit: 10

  pg_search_scope :search_by_name, against: :name, using: { tsearch: { prefix: true } }

  belongs_to :source, polymorphic: true

  has_many :market_sources, foreign_key: :source_id
  has_many :snapshots, class_name: 'MarketOrderSnapshot', foreign_key: :source_id

  has_many :markets, through: :market_sources

  scope :enabled, -> { where.not(status: :disabled) }

  scope :regions, -> { where(source_type: 'Region') }
  scope :structures, -> { where(source_type: 'Structure') }

  delegate :esi_grants, :solar_system_id, :with_esi_token, to: :source

  validates :source_type, inclusion: { in: %w[Region Structure] }

  before_validation :name_from_source, on: :create

  enum :status, %i[
    pending
    fetching
    fetched
    fetching_failed
    disabled
  ].index_with(&:to_s)

  aasm column: :status, enum: true, timestamps: true do # rubocop:disable Metrics/BlockLength
    state :disabled, initial: true
    state :pending
    state :fetching, :fetched, :fetching_failed
    state :authorization_failed

    event :fetch do
      transitions from: %i[pending fetched fetching_failed], to: :fetching, guard: :fetchable?
      after_commit :create_snapshot
    end

    event :finish_fetching do
      transitions from: :fetching, to: :fetched

      before do |snapshot|
        self.expires_at = snapshot.esi_expires_at
        self.status_exception = nil
        etags << snapshot.esi_etag
      end

      error do |snapshot|
        etags.remove(snapshot.esi_etag)
      end
    end

    event :fail_fetching do
      transitions from: :fetching, to: :fetching_failed
      before { |exception| self.status_exception = exception }
      after_commit { |exception| raise exception }
    end

    event :enable do
      transitions from: :disabled, to: :pending, guard: :enableable?
    end

    event :disable do
      transitions from: %i[fetched fetching fetching_failed pending], to: :disabled

      before { |exception| self.status_exception = exception if exception }
      after_commit { |exception| raise exception if exception }
    end
  end

  def self.fetchable
    enabled.select(&:fetchable?)
  end

  def available?
    return false if disabled?

    fetched? && !expired?
  end

  def enableable?
    return true unless source.is_a?(Structure)

    source.esi_authorized?('StructureMarket')
  end

  def fetchable?
    return false if fetching?

    fetching_failed? || expired?
  end

  def expired?
    return true unless expires_at

    expires_at <= Time.zone.now
  end

  def latest
    snapshots.fetched.order(fetched_at: :desc).first
  end

  def latest_at
    latest&.created_at
  end

  def latest_etag
    etags.elements.last
  end

  def previous
    return unless snapshots.any?

    snapshots.fetched.where.not(fetched_at: latest.fetched_at).order(fetched_at: :desc).first
  end

  def previous_at
    previous&.created_at
  end

  def source_url
    case source
    when Region
      "https://esi.evetech.net/latest/markets/#{source_id}/orders/"
    when Structure
      "https://esi.evetech.net/latest/markets/structures/#{source_id}/"
    end
  end

  private

  def create_snapshot
    snapshot = snapshots.create!
    snapshot.fetch!

    finish_fetching!(snapshot.reload)
  rescue MarketOrderSnapshot::NoAuthorizedGrantsError => e
    disable!(e)
    raise
  rescue StandardError => e
    fail_fetching!(e)
    raise
  end

  def name_from_source
    self.name = source.name
  end
end
