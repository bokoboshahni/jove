# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class CelestialImporter < BaseImporter
        self.sde_model = Celestial

        self.sde_rename = {
          height_map1: :height_map_1_id,
          height_map2: :height_map_2_id,
          shader_preset: :shader_preset_id
        }

        self.sde_name_lookup = true
      end
    end
  end
end
