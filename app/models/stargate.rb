# frozen_string_literal: true

# ## Schema Information
#
# Table name: `stargates`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `bigint`           | `not null, primary key`
# **`name`**             | `text`             | `not null`
# **`position_x`**       | `decimal(, )`      | `not null`
# **`position_y`**       | `decimal(, )`      | `not null`
# **`position_z`**       | `decimal(, )`      | `not null`
# **`created_at`**       | `datetime`         | `not null`
# **`updated_at`**       | `datetime`         | `not null`
# **`destination_id`**   | `bigint`           | `not null`
# **`solar_system_id`**  | `bigint`           | `not null`
# **`type_id`**          | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_stargates_on_destination_id`:
#     * **`destination_id`**
# * `index_stargates_on_solar_system_id`:
#     * **`solar_system_id`**
# * `index_stargates_on_type_id`:
#     * **`type_id`**
#
class Stargate < ApplicationRecord
  include SDEImportable

  self.sde_mapper = lambda { |data, context:|
    data[:id] = context[:id]
    data[:solar_system_id] = context[:solar_system_id]
    data[:position_x], data[:position_y], data[:position_z] = data.delete(:position)
  }

  self.sde_name_lookup = true

  self.sde_rename = { destination: :destination_id }

  belongs_to :solar_system
  belongs_to :destination, class_name: 'Stargate'

  def self.import_all_from_sde(progress: nil) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    paths = Dir[File.join(sde_path, 'fsd/universe/**/solarsystem.staticdata')]
    progress&.update(total: paths.count)
    rows = Parallel.map(paths, in_threads: Etc.nprocessors) do |path|
      solar_system = YAML.load_file(path)
      next unless solar_system['stargates']

      stargates = solar_system['stargates'].map do |id, stargate|
        map_sde_attributes(stargate, context: { id:, solar_system_id: solar_system['solarSystemID'] })
      end
      progress&.advance
      stargates
    end
    upsert_all(rows.flatten)
  end
end
