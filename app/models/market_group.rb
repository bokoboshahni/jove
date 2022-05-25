# frozen_string_literal: true

# ## Schema Information
#
# Table name: `market_groups`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`ancestry`**        | `text`             |
# **`ancestry_depth`**  | `integer`          | `default(0), not null`
# **`description`**     | `text`             |
# **`has_types`**       | `boolean`          | `not null`
# **`name`**            | `text`             | `not null`
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`icon_id`**         | `bigint`           |
#
# ### Indexes
#
# * `index_market_groups_on_ancestry`:
#     * **`ancestry`**
# * `index_market_groups_on_icon_id`:
#     * **`icon_id`**
#
class MarketGroup < ApplicationRecord
  include SDEImportable

  self.sde_mapper = lambda { |data, context:|
    if data[:parent_group_id]
      parent_id = data[:parent_group_id]
      ancestry_ids = build_ancestry_from_parent_ids(context[:market_groups], parent_id)
      data[:ancestry] = ancestry_ids.join('/')
      data[:ancestry_depth] = ancestry_ids.count
    else
      data[:ancestry_depth] = 0
    end
  }

  self.sde_exclude = %i[parent_group_id]

  self.sde_localized = %i[description name]

  has_ancestry cache_depth: true

  def self.import_all_from_sde(progress: nil)
    data = YAML.load_file(File.join(sde_path, 'fsd/marketGroups.yaml'))
    rows = Marshal.load(Marshal.dump(data)).map do |id, orig|
      record = map_sde_attributes(orig, id:, context: { market_groups: data })
      progress&.advance
      record
    end
    upsert_all(rows)
  end

  def self.build_ancestry_from_parent_ids(market_groups, parent_id = nil, ancestor_ids = [])
    ancestor_ids.prepend(parent_id)

    parent = market_groups[parent_id]
    build_ancestry_from_parent_ids(market_groups, parent['parentGroupID'], ancestor_ids) if parent['parentGroupID']

    ancestor_ids
  end
end
