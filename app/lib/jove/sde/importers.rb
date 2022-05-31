# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      def self.all
        [
          GraphicImporter, IconImporter,
          RegionImporter, ConstellationImporter, SolarSystemImporter,
          StationOperationImporter, StationServiceImporter,
          CategoryImporter, GroupImporter, MarketGroupImporter, MetaGroupImporter, UnitImporter,
          TypeImporter, DogmaAttributeImporter, DogmaEffectImporter, DogmaCategoryImporter,
          BlueprintActivityImporter, TypeMaterialImporter, PlanetSchematicImporter,
          RaceImporter, BloodlineImporter, CorporationImporter, FactionImporter,
          InventoryFlagImporter
        ]
      end
    end
  end
end
