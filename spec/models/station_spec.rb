# frozen_string_literal: true

# ## Schema Information
#
# Table name: `stations`
#
# ### Columns
#
# Name                               | Type               | Attributes
# ---------------------------------- | ------------------ | ---------------------------
# **`id`**                           | `bigint`           | `not null, primary key`
# **`conquerable`**                  | `boolean`          | `not null`
# **`docking_cost_per_volume`**      | `decimal(, )`      | `not null`
# **`max_ship_volume_dockable`**     | `decimal(, )`      | `not null`
# **`name`**                         | `text`             | `not null`
# **`office_rental_cost`**           | `decimal(, )`      | `not null`
# **`position_x`**                   | `decimal(, )`      | `not null`
# **`position_y`**                   | `decimal(, )`      | `not null`
# **`position_z`**                   | `decimal(, )`      | `not null`
# **`reprocessing_efficiency`**      | `decimal(, )`      | `not null`
# **`reprocessing_station_take`**    | `decimal(, )`      | `not null`
# **`use_operation_name`**           | `boolean`          | `not null`
# **`created_at`**                   | `datetime`         | `not null`
# **`updated_at`**                   | `datetime`         | `not null`
# **`celestial_id`**                 | `bigint`           | `not null`
# **`corporation_id`**               | `bigint`           | `not null`
# **`graphic_id`**                   | `bigint`           | `not null`
# **`operation_id`**                 | `bigint`           | `not null`
# **`reprocessing_hangar_flag_id`**  | `bigint`           | `not null`
# **`type_id`**                      | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_stations_on_celestial_id`:
#     * **`celestial_id`**
# * `index_stations_on_corporation_id`:
#     * **`corporation_id`**
# * `index_stations_on_graphic_id`:
#     * **`graphic_id`**
# * `index_stations_on_operation_id`:
#     * **`operation_id`**
# * `index_stations_on_reprocessing_hangar_flag_id`:
#     * **`reprocessing_hangar_flag_id`**
# * `index_stations_on_type_id`:
#     * **`type_id`**
#
require 'rails_helper'

RSpec.describe Station, type: :model do
  describe '.import_all_from_sde' do
    let(:station_ids) do
      YAML.load_file(File.join(Jove.config.sde_path, 'bsd/staStations.yaml')).map { |s| s['stationID'] }
    end

    it 'saves each station' do
      expect(described_class.import_all_from_sde.rows.flatten).to match_array(station_ids)
    end
  end
end
