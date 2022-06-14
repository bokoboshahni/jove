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
require 'rails_helper'

RSpec.describe Market, type: :model do
  describe '.expired' do
  end

  describe '#aggregate!' do
  end

  describe '#latest' do
  end

  describe '#latest_items_by_type_id' do
  end

  describe '#order_location_ids' do
  end

  describe '#expired?' do
  end

  describe '#regional' do
  end
end
