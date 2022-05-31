# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class GraphicImporter < BaseImporter
        self.sde_file = 'fsd/graphicIDs.yaml'
        self.sde_model = Graphic

        self.sde_mapper = lambda { |data, **_kwargs|
          data[:icon_folder] = data.delete(:icon_info).fetch(:folder) if data[:icon_info]
        }

        self.sde_rename = {
          sof_faction_name: :skin_faction_name,
          sof_hull_name: :skin_hull_name,
          sof_race_name: :skin_race_name
        }
      end
    end
  end
end
