# frozen_string_literal: true

# ## Schema Information
#
# Table name: `planet_schematics`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `bigint`           | `not null, primary key`
# **`name`**             | `text`             | `not null`
# **`output_quantity`**  | `integer`          | `not null`
# **`pins`**             | `integer`          | `not null, is an Array`
# **`time`**             | `interval`         | `not null`
# **`created_at`**       | `datetime`         | `not null`
# **`updated_at`**       | `datetime`         | `not null`
# **`output_id`**        | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_planet_schematics_on_output_id`:
#     * **`output_id`**
#
require 'rails_helper'

RSpec.describe PlanetSchematic, type: :model do
  describe '.import_all_from_sde' do
    let(:schematic_data) do
      YAML.load_file(File.join(Jove.config.sde_path, 'fsd/planetSchematics.yaml'))
    end

    let(:schematic_ids) { schematic_data.keys }

    let(:schematic_input_ids) do
      schematic_data.each_with_object([]) do |(schematic_id, schematic), a|
        schematic['types'].select { |_, type| type['isInput'] }.map(&:first).each do |input_id|
          a << [schematic_id, input_id]
        end
      end
    end

    let(:schematic_pin_ids) do
      schematic_data.each_with_object([]) do |(schematic_id, schematic), a|
        schematic['pins'].each { |p| a << [schematic_id, p] }
      end
    end

    before { described_class.import_all_from_sde }

    it 'saves each planet schematic' do
      expect(described_class.pluck(:id)).to match_array(schematic_ids)
    end

    it 'saves each planet schematic input' do
      expect(PlanetSchematicInput.pluck(:schematic_id, :type_id))
        .to match_array(schematic_input_ids)
    end

    it 'saves each planet schematic pin' do
      expect(PlanetSchematicPin.pluck(:schematic_id, :type_id))
        .to match_array(schematic_pin_ids)
    end
  end
end
