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
require 'rails_helper'

RSpec.describe Stargate, type: :model do
  describe '.import_all_from_sde' do
    let(:stargate_ids) do
      Dir[File.join(Jove.config.sde_path, 'fsd/universe/**/solarsystem.staticdata')].each_with_object([]) do |path, a|
        solar_system = YAML.load_file(path)
        next unless solar_system['stargates']

        solar_system['stargates'].each_key { |stargate_id| a << stargate_id }
      end
    end

    it 'saves each stargate' do
      expect(described_class.import_all_from_sde.rows.flatten).to match_array(stargate_ids)
    end
  end
end
