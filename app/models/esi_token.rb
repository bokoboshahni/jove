# frozen_string_literal: true

require 'jove/esi/scopes'

# ## Schema Information
#
# Table name: `esi_tokens`
#
# ### Columns
#
# Name                             | Type               | Attributes
# -------------------------------- | ------------------ | ---------------------------
# **`id`**                         | `bigint`           | `not null, primary key`
# **`access_token`**               | `text`             |
# **`approved_at`**                | `datetime`         |
# **`authorized_at`**              | `datetime`         |
# **`expired_at`**                 | `datetime`         |
# **`expires_at`**                 | `datetime`         |
# **`grant_type`**                 | `text`             |
# **`refresh_error_code`**         | `text`             |
# **`refresh_error_description`**  | `text`             |
# **`refresh_error_status`**       | `integer`          |
# **`refresh_token`**              | `text`             |
# **`refreshed_at`**               | `datetime`         |
# **`rejected_at`**                | `datetime`         |
# **`resource_type`**              | `string`           |
# **`revoked_at`**                 | `datetime`         |
# **`scopes`**                     | `text`             | `not null, is an Array`
# **`status`**                     | `enum`             | `not null`
# **`used_at`**                    | `datetime`         |
# **`created_at`**                 | `datetime`         | `not null`
# **`updated_at`**                 | `datetime`         | `not null`
# **`identity_id`**                | `bigint`           | `not null`
# **`requester_id`**               | `bigint`           | `not null`
# **`resource_id`**                | `bigint`           |
#
# ### Indexes
#
# * `index_esi_tokens_on_identity_id`:
#     * **`identity_id`**
# * `index_esi_tokens_on_requester_id`:
#     * **`requester_id`**
# * `index_esi_tokens_with_resources`:
#     * **`grant_type`**
#     * **`resource_type`**
#     * **`resource_id`**
# * `index_unique_esi_token_access_tokens` (_unique_):
#     * **`access_token`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`identity_id => identities.id`**
# * `fk_rails_...`:
#     * **`requester_id => identities.id`**
#
class ESIToken < ApplicationRecord # rubocop:disable Metrics/ClassLength
  include AASM

  GRANT_TYPES = {
    structure_discovery: { scopes: %w[esi-universe.read_structures.v1] },
    structure_market: { scopes: %w[esi-markets.structure_markets.v1], resource_types: [Structure] }
  }.freeze

  belongs_to :identity
  belongs_to :requester, class_name: 'Identity'
  belongs_to :resource, polymorphic: true, optional: true

  has_one :character, through: :identity
  has_one :user, through: :identity

  delegate :expired?, to: :current_token, prefix: true, allow_nil: true
  delegate :name, to: :character

  encrypts :access_token, deterministic: true
  encrypts :refresh_token, deterministic: true

  validates :access_token, presence: true, uniqueness: true, if: -> { authorized? }
  validates :refresh_token, presence: true, if: -> { authorized? }
  validates :expires_at, presence: true, if: -> { authorized? }
  validates :scopes, presence: true
  validates :status, presence: true

  with_options if: -> { grant_options[:resource_types] } do |resource_grant|
    resource_grant.validates :resource, presence: true
    resource_grant.validate :resource_type
  end

  scope :active, -> { where.not(status: %i[approved rejected requested revoked]) }

  scope :by_type, ->(type) { where(grant_type: type.to_s) }

  scope :authorized_by_type, ->(type) { by_type(type).authorized }
  scope :approved_by_type, ->(type) { by_type(type).approved }
  scope :requested_by_type, ->(type) { by_type(type).requested }

  enum :status, %i[
    requested
    approved
    rejected
    authorized
    revoked
    expired
  ].index_with(&:to_s)

  before_validation :scopes_from_grant_type, on: :create

  aasm column: :status, enum: true, timestamps: true, whiny_persistence: false do # rubocop:disable Metrics/BlockLength
    state :requested, initial: true
    state :approved, :rejected, :authorized, :revoked, :expired

    event :approve do
      transitions from: :requested, to: :approved
    end

    event :reject do
      transitions from: :requested, to: :rejected
    end

    event :authorize do
      transitions from: :approved, to: :authorized do
        guard { |auth| auth_matches_token?(auth) }
      end

      before { |auth| assign_access_token(auth.credentials) }
    end

    event :expire do
      transitions from: :authorized, to: :expired

      before { |e| assign_refresh_error!(e) }
    end

    event :renew do
      transitions from: :expired, to: :authorized do
        guard { |auth| auth_matches_token?(auth) }
      end

      before { |auth| assign_access_token(auth.credentials) }
    end

    event :revoke do
      transitions from: %i[authorized expired], to: :revoked
    end
  end

  def self.pending_available?(grant_type)
    requested_by_type(grant_type).any? || approved_by_type(grant_type).any?
  end

  def self.available?(grant_type)
    authorized_by_type(grant_type).any?
  end

  def self.unavailable?(grant_type)
    authorized_by_type(grant_type).empty? && approved_by_type(grant_type).empty?
  end

  def self.with_token(grant_type, &)
    authorized_by_type(grant_type).first&.with_token(&)
  end

  def authorize_url(redirect_uri, state)
    Jove.config.esi_oauth_client.auth_code.authorize_url(redirect_uri:, scope: scopes.join(' '), state:)
  end

  def grant_options
    GRANT_TYPES.fetch(grant_type.to_sym)
  end

  def refresh!
    return true unless current_token.expired?

    Retriable.retriable(on: [OAuth2::Error], tries: Rails.env.test? ? 1 : 3) do
      assign_access_token(current_token.refresh!)
      save!
    end

    true
  rescue OAuth2::Error => e
    expire!(e)
    false
  end

  def to_oauth_token
    return unless authorized?

    OAuth2::AccessToken.from_hash(Jove.config.esi_oauth_client, access_token:, refresh_token:, expires_at:)
  end
  alias current_token to_oauth_token

  def with_token
    return false unless authorized?

    return false unless refresh!

    update!(used_at: Time.zone.now)

    yield access_token if block_given?

    true
  end

  private

  delegate :esi_client_id, :esi_client_secret, :esi_oauth_url, to: :jove_config

  def auth_matches_token?(auth)
    scopes == auth.info.scopes.split &&
      identity == Identity.find_by(character_id: auth.uid)
  end

  def assign_access_token(token)
    assign_attributes(
      access_token: token.token,
      refresh_token: token.refresh_token,
      expires_at: Time.zone.at(token.expires_at).to_datetime,
      refreshed_at: Time.zone.now
    )
  end

  def assign_refresh_error!(err)
    assign_attributes(
      access_token: nil,
      refresh_token: nil,
      expires_at: nil,
      refresh_error_code: err.code,
      refresh_error_description: err.description,
      refresh_error_status: err.response.status,
      refreshed_at: Time.zone.now
    )
  end

  def scopes_from_grant_type
    self.scopes = grant_options.fetch(:scopes)
  end
end
