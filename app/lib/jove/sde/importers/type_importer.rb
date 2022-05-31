# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class TypeImporter < BaseImporter
        self.sde_model = Type

        self.sde_mapper = lambda { |data, **_kwargs|
          next unless data[:traits]

          %i[misc_bonuses role_bonuses].each do |bonus_type|
            data[:traits][bonus_type]&.each do |bonus|
              bonus[:bonus_text] = bonus[:bonus_text][:en]
            end
          end

          data[:traits][:types]&.each_value do |bonuses|
            bonuses.each { |bonus| bonus[:bonus_text] = bonus[:bonus_text][:en] }
          end
        }

        self.sde_exclude = %i[masteries]

        self.sde_rename = {
          sof_faction_name: :skin_faction_name,
          sof_material_set_id: :skin_material_set_id
        }

        self.sde_localized = %i[description name]

        def import_all # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          data = YAML.load_file(File.join(sde_path, 'fsd/typeIDs.yaml'))
          dogma = YAML.load_file(File.join(sde_path, 'fsd/typeDogma.yaml'))
          blueprints = YAML.load_file(File.join(sde_path, 'fsd/blueprints.yaml'))
          packaged_volumes = JSON.parse(File.read(Rails.root.join('db/packaged_volumes.json')))
          start_progress(total: data.count)
          rows = data.map do |id, orig|
            blueprint = blueprints[id]
            orig.merge!(max_production_limit: blueprint['maxProductionLimit']) if blueprint
            if dogma[id]
              orig.merge!(
                dogma_attributes: dogma[id]['dogmaAttributes'],
                dogma_effects: dogma[id]['dogmaEffects']
              )
            end
            orig[:packaged_volume] = packaged_volumes[id.to_s]
            record = map_sde_attributes(orig, id:)
            advance_progress
            record
          end
          upsert_all(rows)
          rebuild_multisearch_index
        end
      end
    end
  end
end
