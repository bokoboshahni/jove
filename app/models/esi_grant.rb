# frozen_string_literal: true

# ## Schema Information
#
# Table name: `esi_grants`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`approved_at`**     | `datetime`         |
# **`grantable_type`**  | `string`           |
# **`note`**            | `text`             |
# **`rejected_at`**     | `datetime`         |
# **`revoked_at`**      | `datetime`         |
# **`status`**          | `enum`             | `not null`
# **`type`**            | `text`             | `not null`
# **`used_at`**         | `datetime`         |
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`grantable_id`**    | `bigint`           |
# **`requester_id`**    | `bigint`           | `not null`
# **`token_id`**        | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_esi_grants_on_grantable`:
#     * **`grantable_type`**
#     * **`grantable_id`**
# * `index_esi_grants_on_requester_id`:
#     * **`requester_id`**
# * `index_esi_grants_on_token_id`:
#     * **`token_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`requester_id => identities.id`**
# * `fk_rails_...`:
#     * **`token_id => esi_tokens.id`**
#
class ESIGrant < ApplicationRecord
  include AASM

  cattr_accessor :preloaded, instance_accessor: false

  class_attribute :requested_scopes
  self.requested_scopes = []

  belongs_to :token, class_name: 'ESIToken', optional: true
  belongs_to :grantable, polymorphic: true, optional: true
  belongs_to :requester, class_name: 'Identity'

  has_one :identity, through: :token

  scope :approved_by_type, ->(type) { where(type: "ESIGrant::#{type}").approved }

  delegate :access_token, to: :token
  delegate :authorized?, to: :token

  enum :status, %i[
    requested
    approved
    rejected
    revoked
  ].index_with(&:to_s)

  aasm column: :status, enum: true, timestamps: true, whiny_persistence: false do
    state :requested, initial: true
    state :approved, :rejected, :revoked

    event :approve do
      transitions from: :requested, to: :approved
    end

    event :reject do
      transitions from: :requested, to: :rejected
    end

    event :revoke do
      transitions from: :approved, to: :revoked
    end
  end

  def self.descendants
    %w[ESIGrant::StructureDiscovery ESIGrant::StructureMarket].each(&:constantize) unless preloaded
    self.preloaded = true

    super
  end

  def self.authorized_by_type(grant_type)
    approved_by_type(grant_type).select(&:authorized?)
  end

  def self.available?
    approved.any? && approved.all?(&:authorized?)
  end

  def self.unavailable?
    approved.empty? || approved.all? { |g| !g.authorized? }
  end

  def self.pending_available?
    approved.empty? && requested.any?
  end

  def self.preferred
    approved.first
  end

  def self.with_token(&)
    preferred.with_token(&)
  end

  def with_token
    return false unless approved?

    return false unless authorized?

    return false unless token.refresh!

    update!(used_at: Time.zone.now)

    yield access_token if block_given?

    true
  end
end
