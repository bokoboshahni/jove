# frozen_string_literal: true

# ## Schema Information
#
# Table name: `faction_races`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`log_data`**    | `jsonb`            |
# **`faction_id`**  | `bigint`           | `not null, primary key`
# **`race_id`**     | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_faction_races_on_faction_id`:
#     * **`faction_id`**
# * `index_faction_races_on_race_id`:
#     * **`race_id`**
# * `index_unique_faction_races` (_unique_):
#     * **`faction_id`**
#     * **`race_id`**
#
class FactionRace < ApplicationRecord
  include SDEImportable

  self.primary_keys = :faction_id, :race_id

  belongs_to :faction
  belongs_to :race
end
