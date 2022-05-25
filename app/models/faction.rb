# frozen_string_literal: true

# ## Schema Information
#
# Table name: `factions`
#
# ### Columns
#
# Name                          | Type               | Attributes
# ----------------------------- | ------------------ | ---------------------------
# **`id`**                      | `bigint`           | `not null, primary key`
# **`description`**             | `text`             | `not null`
# **`name`**                    | `text`             | `not null`
# **`short_description`**       | `text`             |
# **`size_factor`**             | `decimal(, )`      | `not null`
# **`created_at`**              | `datetime`         | `not null`
# **`updated_at`**              | `datetime`         | `not null`
# **`corporation_id`**          | `bigint`           |
# **`icon_id`**                 | `bigint`           | `not null`
# **`militia_corporation_id`**  | `bigint`           |
# **`solar_system_id`**         | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_factions_on_corporation_id`:
#     * **`corporation_id`**
# * `index_factions_on_icon_id`:
#     * **`icon_id`**
# * `index_factions_on_militia_corporation_id`:
#     * **`militia_corporation_id`**
# * `index_factions_on_solar_system_id`:
#     * **`solar_system_id`**
#
class Faction < ApplicationRecord
  include SDEImportable

  self.sde_exclude = %i[member_races unique_name]

  self.sde_localized = %i[description name short_description]

  has_many :faction_races

  has_many :races, through: :faction_races

  def self.import_all_from_sde(progress: nil) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    data = YAML.load_file(File.join(sde_path, 'fsd/factions.yaml'))
    progress&.update(total: data.count)

    faction_races = data.map do |faction_id, faction|
      faction['memberRaces']&.map { |race_id| { faction_id:, race_id: } }
    end.flatten.compact
    FactionRace.upsert_all(faction_races)

    rows = data.map do |id, orig|
      record = map_sde_attributes(orig, id:)
      progress&.advance
      record
    end
    upsert_all(rows)
  end
end
