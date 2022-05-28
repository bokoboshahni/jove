# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      def self.all
        [
          GraphicImporter, IconImporter,
          RegionImporter, ConstellationImporter, SolarSystemImporter,
          StarImporter, SecondarySunImporter, PlanetImporter, MoonImporter, AsteroidBeltImporter,
          StargateImporter, StationImporter, StationOperationImporter, StationServiceImporter,
          CategoryImporter, GroupImporter, MarketGroupImporter, MetaGroupImporter, UnitImporter,
          TypeImporter, DogmaAttributeImporter, DogmaEffectImporter, DogmaEffectModifierImporter, DogmaCategoryImporter,
          BlueprintActivityImporter, TypeMaterialImporter, PlanetSchematicImporter,
          RaceImporter, BloodlineImporter, CorporationImporter, FactionImporter
        ]
      end
    end
  end
end
