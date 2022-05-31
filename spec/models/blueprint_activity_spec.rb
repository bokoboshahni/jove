# frozen_string_literal: true

# ## Schema Information
#
# Table name: `blueprint_activities`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`activity`**      | `enum`             | `not null, primary key`
# **`log_data`**      | `jsonb`            |
# **`time`**          | `interval`         | `not null`
# **`blueprint_id`**  | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_blueprint_activities_on_blueprint_id`:
#     * **`blueprint_id`**
# * `index_unique_blueprint_activities` (_unique_):
#     * **`blueprint_id`**
#     * **`activity`**
#
require 'rails_helper'

RSpec.describe BlueprintActivity, type: :model do
end
