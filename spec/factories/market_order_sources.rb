# frozen_string_literal: true

# ## Schema Information
#
# Table name: `market_order_sources`
#
# ### Columns
#
# Name                      | Type               | Attributes
# ------------------------- | ------------------ | ---------------------------
# **`id`**                  | `integer`          | `not null, primary key`
# **`disabled_at`**         | `datetime`         |
# **`expires_at`**          | `datetime`         |
# **`fetched_at`**          | `datetime`         |
# **`fetching_at`**         | `datetime`         |
# **`fetching_failed_at`**  | `datetime`         |
# **`name`**                | `text`             | `not null`
# **`pending_at`**          | `datetime`         |
# **`source_type`**         | `string`           | `not null`
# **`status`**              | `enum`             | `not null`
# **`status_exception`**    | `jsonb`            |
# **`created_at`**          | `datetime`         | `not null`
# **`updated_at`**          | `datetime`         | `not null`
# **`source_id`**           | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_unique_market_order_sources` (_unique_):
#     * **`source_type`**
#     * **`source_id`**
#
FactoryBot.define do
  factory :market_order_source do
    association :source, factory: :region

    trait :pending do
      status { :pending }
    end

    trait :disabled do
      status { :disabled }
      disabled_at { Time.zone.now }
    end

    trait :fetched do
      status { :fetched }
      fetched_at { Time.zone.now }
      expires_at { 5.minutes.from_now }
    end

    trait :expired do
      expires_at { 5.minutes.ago }
    end

    trait :fetchable do
      status { :fetched }
      expires_at { 5.minutes.ago }
    end
  end
end
