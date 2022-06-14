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
FactoryBot.define do
  factory :market do
    name { Faker::Space.galaxy }

    after(:build) do |market|
      market.locations << FactoryBot.build(:market_location)
      market.market_sources << FactoryBot.build(:market_source)
    end
  end
end
