# frozen_string_literal: true

# ## Schema Information
#
# Table name: `types`
#
# ### Columns
#
# Name                            | Type               | Attributes
# ------------------------------- | ------------------ | ---------------------------
# **`id`**                        | `bigint`           | `not null, primary key`
# **`base_price`**                | `decimal(, )`      |
# **`capacity`**                  | `decimal(, )`      |
# **`description`**               | `text`             |
# **`mass`**                      | `decimal(, )`      |
# **`max_production_limit`**      | `integer`          |
# **`name`**                      | `text`             | `not null`
# **`packaged_volume`**           | `decimal(, )`      |
# **`portion_size`**              | `integer`          | `not null`
# **`published`**                 | `boolean`          | `not null`
# **`radius`**                    | `decimal(, )`      |
# **`skin_faction_name`**         | `text`             |
# **`volume`**                    | `decimal(, )`      |
# **`created_at`**                | `datetime`         | `not null`
# **`updated_at`**                | `datetime`         | `not null`
# **`faction_id`**                | `bigint`           |
# **`graphic_id`**                | `bigint`           |
# **`group_id`**                  | `bigint`           | `not null`
# **`icon_id`**                   | `bigint`           |
# **`market_group_id`**           | `bigint`           |
# **`meta_group_id`**             | `bigint`           |
# **`race_id`**                   | `bigint`           |
# **`skin_material_set_id`**      | `bigint`           |
# **`sound_id`**                  | `bigint`           |
# **`variation_parent_type_id`**  | `bigint`           |
#
# ### Indexes
#
# * `index_types_on_faction_id`:
#     * **`faction_id`**
# * `index_types_on_graphic_id`:
#     * **`graphic_id`**
# * `index_types_on_group_id`:
#     * **`group_id`**
# * `index_types_on_icon_id`:
#     * **`icon_id`**
# * `index_types_on_market_group_id`:
#     * **`market_group_id`**
# * `index_types_on_meta_group_id`:
#     * **`meta_group_id`**
# * `index_types_on_race_id`:
#     * **`race_id`**
# * `index_types_on_skin_material_set_id`:
#     * **`skin_material_set_id`**
# * `index_types_on_sound_id`:
#     * **`sound_id`**
# * `index_types_on_variation_parent_type_id`:
#     * **`variation_parent_type_id`**
#
class Type < ApplicationRecord
  include SDEImportable

  self.sde_exclude = %i[masteries traits]

  self.sde_rename = {
    sof_faction_name: :skin_faction_name,
    sof_material_set_id: :skin_material_set_id
  }

  self.sde_localized = %i[description name]

  belongs_to :faction, optional: true
  belongs_to :graphic, optional: true
  belongs_to :group
  belongs_to :icon, optional: true
  belongs_to :market_group, optional: true
  belongs_to :meta_group, optional: true
  belongs_to :variation_parent_type, optional: true

  has_one :planet_schematic_as_output, class_name: 'PlanetSchematic', foreign_key: :output_id

  has_many :stations
  has_many :station_operation_station_types

  has_many :blueprint_activities, foreign_key: :blueprint_id
  has_many :blueprint_products, class_name: 'BlueprintActivityProduct', foreign_key: :blueprint_id
  has_many :blueprint_materials, class_name: 'BlueprintActivityMaterial', foreign_key: :blueprint_id
  has_many :blueprint_skills, class_name: 'BlueprintActivitySkill', foreign_key: :blueprint_id

  has_many :blueprint_activity_products_as_product, foreign_key: :product_id
  has_many :blueprint_activities_as_product, class_name: 'BlueprintActivity',
                                             through: :blueprint_activity_products_as_product,
                                             source: :activity
  has_many :blueprints_as_product, class_name: 'Type', through: :blueprint_activities_as_product,
                                   source: :blueprint

  has_many :blueprint_activity_materials_as_material, foreign_key: :material_id
  has_many :blueprint_activities_as_material, class_name: 'BlueprintActivity',
                                              through: :blueprint_activity_materials_as_material,
                                              source: :activity
  has_many :blueprints_as_material, class_name: 'Type', through: :blueprint_activities_as_material,
                                    source: :blueprint

  has_many :blueprint_activity_skills_as_skill, foreign_key: :skill_id
  has_many :blueprint_activities_as_skill, class_name: 'BlueprintActivity',
                                           through: :blueprint_activity_skills_as_skill,
                                           source: :activity
  has_many :blueprints_as_skill, class_name: 'Type', through: :blueprint_activities_as_skill, source: :blueprint

  has_many :planet_schematic_inputs
  has_many :planet_schematics_as_input, class_name: 'PlanetSchematic', through: :planet_schematic_inputs,
                                        source: :schematic

  has_many :planet_schematic_pins
  has_many :planet_schematics_as_pin, class_name: 'PlanetSchematic', through: :planet_schematic_pins, source: :schematic

  has_many :type_materials_as_type, class_name: 'TypeMaterial', foreign_key: :type_id
  has_many :materials, class_name: 'Type', through: :type_materials_as_type

  has_many :type_materials_as_material, class_name: 'TypeMaterial', foreign_key: :material_id
  has_many :types_as_material, class_name: 'Type', through: :type_materials_as_material, source: :type

  def self.import_all_from_sde(progress: nil) # rubocop:disable Metrics/MethodLength
    data = YAML.load_file(File.join(sde_path, 'fsd/typeIDs.yaml'))
    blueprints = YAML.load_file(File.join(sde_path, 'fsd/blueprints.yaml'))
    progress&.update(total: data.count)
    rows = data.map do |id, orig|
      blueprint = blueprints[id]
      orig.merge!(max_production_limit: blueprint['maxProductionLimit']) if blueprint
      record = map_sde_attributes(orig, id:)
      progress&.advance
      record
    end
    upsert_all(rows)
  end
end
