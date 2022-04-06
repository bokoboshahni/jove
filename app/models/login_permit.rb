# frozen_string_literal: true

# ## Schema Information
#
# Table name: `login_permits`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`id`**                | `bigint`           | `not null, primary key`
# **`name`**              | `text`             | `not null`
# **`permittable_type`**  | `string`           |
# **`created_at`**        | `datetime`         | `not null`
# **`permittable_id`**    | `bigint`           |
#
# ### Indexes
#
# * `index_login_permits_on_permittable`:
#     * **`permittable_type`**
#     * **`permittable_id`**
# * `index_unique_login_permits` (_unique_):
#     * **`permittable_type`**
#     * **`permittable_id`**
#
class LoginPermit < ApplicationRecord
  PERMITTABLE_TYPES = %w[Alliance Character Corporation].freeze

  belongs_to :permittable, polymorphic: true

  delegate :avatar_url, :name, to: :permittable

  validates :permittable_type, presence: true, inclusion: { in: PERMITTABLE_TYPES }

  validates :permittable_id, presence: true, uniqueness: { scope: :permittable_type }

  before_validation :sync_permittable, on: :create

  def self.permitted?(permittable)
    exists?(permittable:)
  end

  def locked?
    return true if permittable.is_a?(Character) && permittable.user&.admin?

    false
  end

  private

  def sync_permittable # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    return unless permittable_id.present? && permittable_type.present?

    self.permittable =
      case permittable_type
      when 'Alliance'
        AllianceRepository.new(gateway: AllianceRepository::ESIGateway.new).find(permittable_id)
      when 'Character'
        CharacterRepository.new(gateway: CharacterRepository::ESIGateway.new).find(permittable_id)
      when 'Corporation'
        CorporationRepository.new(gateway: CorporationRepository::ESIGateway.new).find(permittable_id)
      end
    self.name = permittable.name
  rescue ActiveRecord::RecordNotFound
    self.permittable = nil
  end
end
