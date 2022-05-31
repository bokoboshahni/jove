# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class MarketGroupImporter < BaseImporter
        self.sde_model = MarketGroup

        self.sde_mapper = lambda { |data, context:|
          if data[:parent_group_id]
            parent_id = data[:parent_group_id]
            ancestry_ids = build_ancestry_from_parent_ids(context[:market_groups], parent_id)
            data[:ancestry] = ancestry_ids.join('/')
            data[:ancestry_depth] = ancestry_ids.count
          else
            data[:ancestry_depth] = 0
          end
        }

        self.sde_exclude = %i[parent_group_id]

        self.sde_localized = %i[description name]

        def import_all
          data = YAML.load_file(File.join(sde_path, 'fsd/marketGroups.yaml'))
          rows = Marshal.load(Marshal.dump(data)).map do |id, orig|
            record = map_sde_attributes(orig, id:, context: { market_groups: data })
            advance_progress
            record
          end
          upsert_all(rows)
          rebuild_multisearch_index
        end

        def self.build_ancestry_from_parent_ids(market_groups, parent_id = nil, ancestor_ids = [])
          ancestor_ids.prepend(parent_id)

          parent = market_groups[parent_id]
          if parent['parentGroupID']
            build_ancestry_from_parent_ids(market_groups, parent['parentGroupID'],
                                           ancestor_ids)
          end

          ancestor_ids
        end
      end
    end
  end
end
