# frozen_string_literal: true

# ## Schema Information
#
# Table name: `faction_races`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
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
require 'rails_helper'

RSpec.describe FactionRace, type: :model do
end
