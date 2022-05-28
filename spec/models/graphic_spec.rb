# frozen_string_literal: true

# ## Schema Information
#
# Table name: `graphics`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `bigint`           | `not null, primary key`
# **`description`**        | `text`             |
# **`graphic_file`**       | `text`             |
# **`icon_folder`**        | `text`             |
# **`log_data`**           | `jsonb`            |
# **`skin_faction_name`**  | `text`             |
# **`skin_hull_name`**     | `text`             |
# **`skin_race_name`**     | `text`             |
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
#
require 'rails_helper'

RSpec.describe Graphic, type: :model do
end
