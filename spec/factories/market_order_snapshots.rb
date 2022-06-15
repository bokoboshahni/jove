# frozen_string_literal: true

# ## Schema Information
#
# Table name: `market_order_snapshots`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`esi_etag`**              | `text`             |
# **`esi_expires_at`**        | `datetime`         | `primary key`
# **`esi_last_modified_at`**  | `datetime`         |
# **`failed_at`**             | `datetime`         |
# **`fetched_at`**            | `datetime`         |
# **`fetching_at`**           | `datetime`         |
# **`skipped_at`**            | `datetime`         |
# **`status`**                | `enum`             | `not null`
# **`status_exception`**      | `jsonb`            |
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`source_id`**             | `integer`          | `not null, primary key`
#
# ### Indexes
#
# * `index_unique_market_order_snapshots` (_unique_):
#     * **`source_id`**
#     * **`esi_expires_at`**
#     * **`created_at`**
# * `market_order_snapshots_created_at_idx`:
#     * **`created_at`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`source_id => market_order_sources.id`**
#
FactoryBot.define do
  factory :market_order_snapshot do
    trait :fetched do
      status { :fetched }
      fetched_at { Time.zone.now }
      esi_expires_at { Faker::Time.between(from: Time.zone.now, to: 5.minutes.from_now) }
    end

    trait :failed do
      status { :failed }
      status_exception { Jove::ESI::Error.new }
      failed_at { Time.zone.now }
    end
  end
end
