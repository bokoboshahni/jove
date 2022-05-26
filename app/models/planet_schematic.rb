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
class PlanetSchematic < ApplicationRecord
  include SDEImportable

  self.sde_mapper = lambda { |data, **_kwargs|
    data[:time] = data.delete(:cycle_time).seconds
    output_id, output = data[:types].find { |_type_id, type| !type[:is_input] }
    data[:output_id] = output_id
    data[:output_quantity] = output[:quantity]
  }

  self.sde_exclude = %i[types]

  self.sde_localized = %i[name]

  belongs_to :output, class_name: 'Type'

  has_many :inputs, class_name: 'PlanetSchematicInput', foreign_key: :schematic_id
  has_many :pins, class_name: 'PlanetSchematicPin', foreign_key: :schematic_id

  def self.import_all_from_sde(progress: nil) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    data = YAML.load_file(File.join(sde_path, 'fsd/planetSchematics.yaml'))
    progress&.update(total: data.count)

    inputs = []
    pins = []

    data.each do |schematic_id, schematic|
      schematic['pins'].each { |type_id| pins << { schematic_id:, type_id: } }
      schematic['types'].select { |_, t| t['isInput'] }.each do |type_id, input|
        inputs << { schematic_id:, type_id:, quantity: input['quantity'] }
      end
    end

    rows = data.map do |id, orig|
      record = map_sde_attributes(orig, id:)
      progress&.advance
      record
    end

    PlanetSchematic.transaction do
      PlanetSchematicInput.upsert_all(inputs)
      PlanetSchematicPin.upsert_all(pins)
      upsert_all(rows)
    end
  end
end
