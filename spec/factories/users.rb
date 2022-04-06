# frozen_string_literal: true

# ## Schema Information
#
# Table name: `users`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`admin`**       | `boolean`          |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#
FactoryBot.define do
  factory :user do
    trait :admin do
      admin { true }
    end

    trait :with_default_identity do
      after(:create) do |user, _|
        character = create(:character)
        create(:login_permit, permittable: character)
        create(:identity, user:, character:, default: true)
      end
    end

    factory :admin_user, traits: %i[admin with_default_identity]

    factory :registered_user, traits: %i[with_default_identity]
  end
end
