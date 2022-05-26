# frozen_string_literal: true

# ## Schema Information
#
# Table name: `dogma_attributes`
#
# ### Columns
#
# Name                              | Type               | Attributes
# --------------------------------- | ------------------ | ---------------------------
# **`id`**                          | `bigint`           | `not null, primary key`
# **`default_value`**               | `decimal(, )`      | `not null`
# **`description`**                 | `text`             |
# **`display_name`**                | `text`             |
# **`display_when_zero`**           | `boolean`          |
# **`high_is_good`**                | `boolean`          | `not null`
# **`name`**                        | `text`             | `not null`
# **`published`**                   | `boolean`          | `not null`
# **`stackable`**                   | `boolean`          | `not null`
# **`tooltip_description`**         | `text`             |
# **`tooltip_title`**               | `text`             |
# **`created_at`**                  | `datetime`         | `not null`
# **`updated_at`**                  | `datetime`         | `not null`
# **`category_id`**                 | `bigint`           |
# **`data_type_id`**                | `bigint`           |
# **`icon_id`**                     | `bigint`           |
# **`max_attribute_id`**            | `bigint`           |
# **`recharge_time_attribute_id`**  | `bigint`           |
# **`unit_id`**                     | `bigint`           |
#
# ### Indexes
#
# * `index_dogma_attributes_on_category_id`:
#     * **`category_id`**
# * `index_dogma_attributes_on_data_type_id`:
#     * **`data_type_id`**
# * `index_dogma_attributes_on_icon_id`:
#     * **`icon_id`**
# * `index_dogma_attributes_on_max_attribute_id`:
#     * **`max_attribute_id`**
# * `index_dogma_attributes_on_recharge_time_attribute_id`:
#     * **`recharge_time_attribute_id`**
# * `index_dogma_attributes_on_unit_id`:
#     * **`unit_id`**
#
FactoryBot.define do
  factory :dogma_attribute do
  end
end
