# frozen_string_literal: true

require 'jove/esi/errors'

# ## Schema Information
#
# Table name: `market_order_snapshots`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`esi_etag`**              | `text`             |
# **`esi_expires_at`**        | `datetime`         | `primary key`
# **`esi_last_modified_at`**  | `datetime`         |
# **`failed_at`**             | `datetime`         |
# **`fetched_at`**            | `datetime`         |
# **`fetching_at`**           | `datetime`         |
# **`skipped_at`**            | `datetime`         |
# **`status`**                | `enum`             | `not null`
# **`status_exception`**      | `jsonb`            |
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`source_id`**             | `integer`          | `not null, primary key`
#
# ### Indexes
#
# * `index_unique_market_order_snapshots` (_unique_):
#     * **`source_id`**
#     * **`esi_expires_at`**
#     * **`created_at`**
# * `market_order_snapshots_created_at_idx`:
#     * **`created_at`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`source_id => market_order_sources.id`**
#
class MarketOrderSnapshot < ApplicationRecord # rubocop:disable Metrics/ClassLength
  include AASM
  include ESISyncable

  class Error < StandardError; end

  class NoAuthorizedGrantsError < Error; end

  self.primary_keys = :source_id, :esi_expires_at

  acts_as_hypertable time_column: :created_at

  belongs_to :source, class_name: 'MarketOrderSource'

  has_many :market_live_sources_as_latest, class_name: 'MarketLiveSource', foreign_key: %i[source_id latest_at]
  has_many :market_live_sources_as_previous, class_name: 'MarketLiveSource', foreign_key: %i[source_id previous_at]
  has_many :orders, class_name: 'MarketOrder', foreign_key: %i[source_id created_at], dependent: :delete_all

  has_many :live_snapshots, class_name: 'MarketLiveSnapshot', through: :market_live_sources_as_latest
  has_many :live_items, class_name: 'MarketLiveItem', through: :live_snapshots, source: :items

  enum :status, %i[
    pending
    fetching
    fetched
    failed
    skipped
  ].index_with(&:to_s)

  validates :created_at, uniqueness: { scope: %i[source_id esi_expires_at] }
  validates :status, presence: true

  aasm column: :status, enum: true, timestamps: true do
    state :pending, initial: true
    state :fetching, :fetched, :failed
    state :skipped

    event :fetch do
      transitions from: %i[pending failed], to: :fetching
      after_commit :fetch_from_esi
    end

    event :finish do
      transitions from: :fetching, to: :fetched
      before { self.status_exception = nil }
    end

    event :fail do
      transitions from: :fetching, to: :failed
      before { |exception| self.status_exception = exception }
      after_commit { |exception| raise exception }
    end

    event :skip do
      transitions from: :fetching, to: :skipped
      before { self.status_exception = nil }
    end
  end

  private

  attr_accessor :not_modified, :page_count

  delegate :source_type, :source_url, to: :source

  def fetch_from_esi
    fetch_page_count

    if not_modified
      skip!
    else
      fetch_pages
      finish!
    end
  rescue StandardError => e
    fail!(e)
    raise
  end

  def fetch_page_count # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    res = with_esi_retries do
      req = Typhoeus::Request.new(source_url, method: :head, headers: headers_with_etag)
      req.on_headers do |response|
        if response.code == 304
          self.not_modified = true
          next
        else
          self.not_modified = false
        end

        raise_esi_error(response) unless response.success?

        raise Jove::ESI::Error(response) if response.headers['etag'].blank?
      end
      req.run
    end

    assign_caching_and_page_count(res.headers)
  end

  def fetch_pages
    pending_pages = build_pages(page_count)

    while pending_pages.any?
      with_esi_retries do
        pending_pages.each { |page| queue_request(page, pending_pages) }
        hydra.run
      end
    end
  end

  def assign_caching_and_page_count(headers)
    assign_attributes(
      esi_etag: headers['etag'].gsub(/"/, ''),
      esi_expires_at: headers['expires'].to_datetime.change(usec: 0),
      esi_last_modified_at: headers['last-modified'].to_datetime.change(usec: 0)
    )
    self.page_count = headers['X-Pages'].to_i
  end

  def build_pages(_count)
    page_count.times.to_a.map { |n| n + 1 }
  end

  def queue_request(page, pending_pages)
    req = build_request(page)
    req.on_complete do |res|
      raise_esi_error(res) unless res.success?

      order_rows = map_order_rows(res.body)
      insert_order_rows(order_rows)
      pending_pages.delete(page)
    end
    hydra.queue(req)
  end

  def build_request(page)
    Typhoeus::Request.new(
      source_url,
      params: { page: },
      headers: headers.merge(etag: esi_etag),
      accept_encoding: 'gzip'
    )
  end

  def map_order_rows(response_body)
    rows = Oj.load(response_body).map!(&:symbolize_keys!)
    rows.map! do |order|
      order[:system_id] = source.solar_system_id if source_type == 'Structure'
      order.merge!(created_at:, source_id:)
    end
  end

  def insert_order_rows(rows)
    return if rows.empty?

    MarketOrder.upsert_all(rows, unique_by: %i[source_id order_id created_at], record_timestamps: false,
                                 returning: false)
  end

  def headers
    @headers ||=
      begin
        h = { 'User-Agent' => Jove.config.user_agent, 'Accept' => 'application/json' }
        add_authorization(h) if source_type == 'Structure'

        h
      end
  end

  def headers_with_etag
    headers.merge('If-None-Match' => source.latest_etag) if source.latest_etag
    headers
  end

  def hydra
    @hydra ||= Typhoeus::Hydra.new(max_concurrency: 5)
  end

  def with_esi_retries(&)
    tries = Rails.env.test? ? 2 : 5 # :nocov:
    Retriable.retriable(on: [Jove::ESI::ServerError], base_interval: 1.0, multiplier: 2.0, tries:, &)
  end

  def raise_esi_error(response = nil)
    error_class = Jove::ESI::Error.for(response)
    raise error_class, response
  end

  def add_authorization(headers)
    auth_result = source.with_esi_token(:structure_market) { |t| headers.merge!('Authorization' => "Bearer #{t}") }
    unless auth_result # rubocop:disable Style/GuardClause
      raise NoAuthorizedGrantsError,
            "No authorized grants for structure #{source.name} (#{source.source_id})"
    end
  end
end
