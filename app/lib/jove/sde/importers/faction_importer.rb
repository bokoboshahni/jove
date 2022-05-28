# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class FactionImporter < BaseImporter
        self.sde_model = Faction

        self.sde_exclude = %i[member_races unique_name]

        self.sde_localized = %i[description name short_description]

        def import_all # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          data = YAML.load_file(File.join(sde_path, 'fsd/factions.yaml'))
          progress&.update(total: data.count)

          faction_races = data.map do |faction_id, faction|
            faction['memberRaces']&.map { |race_id| { faction_id:, race_id: } }
          end.flatten.compact
          ::FactionRace.upsert_all(faction_races)

          rows = data.map do |id, orig|
            record = map_sde_attributes(orig, id:)
            progress&.advance
            record
          end
          sde_model.upsert_all(rows)
        end
      end
    end
  end
end
