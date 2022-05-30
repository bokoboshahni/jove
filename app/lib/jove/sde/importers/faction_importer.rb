# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class FactionImporter < BaseImporter
        self.sde_model = Faction

        self.sde_exclude = %i[member_races unique_name]

        self.sde_localized = %i[description name short_description]

        def import_all
          data = YAML.load_file(File.join(sde_path, 'fsd/factions.yaml'))
          progress&.update(total: data.count)
          data.each do |faction_id, faction|
            races = map_races(faction_id, faction['memberRaces'])
            upsert_faction(faction_id, faction, races)
            progress&.advance
          end
        end

        private

        def upsert_faction(faction_id, faction, races)
          sde_model.transaction do
            FactionRace.upsert_all(races, returning: false)
            sde_model.upsert(map_sde_attributes(faction, id: faction_id), returning: false)
          end
        end

        def map_races(faction_id, races)
          races&.map { |race_id| { faction_id:, race_id: } }
        end
      end
    end
  end
end
