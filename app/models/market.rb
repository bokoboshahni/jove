# frozen_string_literal: true

# ## Schema Information
#
# Table name: `markets`
#
# ### Columns
#
# Name                         | Type               | Attributes
# ---------------------------- | ------------------ | ---------------------------
# **`id`**                     | `integer`          | `not null, primary key`
# **`aggregated_at`**          | `datetime`         |
# **`aggregating_at`**         | `datetime`         |
# **`aggregating_failed_at`**  | `datetime`         |
# **`description`**            | `text`             |
# **`disabled_at`**            | `datetime`         |
# **`expires_at`**             | `datetime`         |
# **`hub`**                    | `boolean`          |
# **`name`**                   | `text`             | `not null`
# **`pending_at`**             | `datetime`         |
# **`regional`**               | `boolean`          |
# **`slug`**                   | `text`             | `not null`
# **`status`**                 | `enum`             | `not null`
# **`status_exception`**       | `jsonb`            |
# **`created_at`**             | `datetime`         | `not null`
# **`updated_at`**             | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_unique_market_slugs` (_unique_):
#     * **`slug`**
#
class Market < ApplicationRecord
  extend FriendlyId
  include AASM
  include Searchable

  multisearchable against: %i[name description]

  has_many :locations, class_name: 'MarketLocation', dependent: :destroy
  has_many :market_sources, class_name: 'MarketSource', dependent: :destroy

  has_many :sources, class_name: 'MarketOrderSource', through: :market_sources

  scope :enabled, -> { where.not(status: :disabled) }

  scope :hubs, -> { where(hub: true) }

  accepts_nested_attributes_for :locations
  accepts_nested_attributes_for :market_sources

  friendly_id :name, use: :slugged

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :status, presence: true

  enum :status, %i[
    pending
    disabled
  ].index_with(&:to_s)

  with_options unless: :disabled? do |enabled|
    enabled.validates :locations, length: { minimum: 1 }
    enabled.validates :market_sources, length: { minimum: 1 }
  end

  validates :name, presence: true

  aasm column: :status, enum: true, timestamps: true do
    state :disabled, initial: true
    state :pending

    event :enable do
      transitions from: :disabled, to: :pending
    end

    event :disable do
      transitions from: %i[pending], to: :disabled
    end
  end

  def enableable?
    return false unless locations.count.positive?

    return false unless sources.count.positive?

    return false unless sources_available?

    true
  end

  def sources_available?
    sources.all?(&:available?)
  end

  def order_location_ids
    locations.map(&:location_id)
  end

  def expired?
    return true unless expires_at

    expires_at <= Time.zone.now
  end

  private

  def should_generate_new_friendly_id?
    name_changed?
  end
end
