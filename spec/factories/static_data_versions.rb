# frozen_string_literal: true

# ## Schema Information
#
# Table name: `static_data_versions`
#
# ### Columns
#
# Name                         | Type               | Attributes
# ---------------------------- | ------------------ | ---------------------------
# **`id`**                     | `bigint`           | `not null, primary key`
# **`checksum`**               | `text`             | `not null`
# **`current`**                | `boolean`          |
# **`downloaded_at`**          | `datetime`         |
# **`downloading_at`**         | `datetime`         |
# **`downloading_failed_at`**  | `datetime`         |
# **`imported_at`**            | `datetime`         |
# **`importing_at`**           | `datetime`         |
# **`importing_failed_at`**    | `datetime`         |
# **`status`**                 | `enum`             | `not null`
# **`status_exception`**       | `jsonb`            |
# **`status_log`**             | `text`             | `is an Array`
# **`created_at`**             | `datetime`         | `not null`
# **`updated_at`**             | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_static_data_versions_on_checksum` (_unique_):
#     * **`checksum`**
# * `index_static_data_versions_on_current` (_unique_):
#     * **`current`**
#
FactoryBot.define do
  factory :static_data_version do
    checksum { SecureRandom.hex(32) }

    trait :current do
      current { true }
    end

    trait :failed do
      status_exception { Exception.new.as_json }
    end

    trait :downloaded do
      downloaded_at { 10.minutes.ago }
      status { :downloaded }

      before(:create) do |version|
        version.archive.attach(
          io: File.open(Rails.root.join('spec/fixtures/sde-tiny.zip')),
          filename: "sde-#{version.checksum}.zip",
          content_type: 'application/zip'
        )
      end
    end
  end
end
