# frozen_string_literal: true

require 'benchmark'

IMPORT_PROGRESS_FORMAT = '[:bar] :current/:total :percent ET::elapsed ETA::eta :rate/s'

SDE_PATH = ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde'))

namespace :sde do # rubocop:disable Metrics/BlockLength
  task check: :environment do
    version = StaticDataVersion.check_for_new_version!
    version ||= StaticDataVersion.order(created_at: :desc).first
    puts version.id
  end

  task clean: :environment do
    FileUtils.rm_rf(Rails.root.join('tmp/sde'))
    FileUtils.rm_f(Rails.root.join('tmp/sde.zip'))
  end

  task download: :environment do
    sde_file = Rails.root.join('tmp/sde.zip')
    Down.download(Jove.config.sde_archive_url, destination: sde_file)
    Dir.chdir(Rails.root.join('tmp')) { system('unzip sde.zip') }
  end

  task import: :environment do
    sde_version = ENV.fetch('SDE_VERSION_ID')
    sde_version.import!
  end

  task fixtures: :environment do
    require 'jove/sde/fixtures'
    Jove::SDE::Fixtures.new.generate
  end

  namespace :import do # rubocop:disable Metrics/BlockLength
    task bloodlines: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Bloodlines #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::BloodlineImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{Bloodline.count} bloodlines"
      end
    end

    task blueprint_activities: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Blueprint Activities#{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::BlueprintActivityImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{BlueprintActivity.count} blueprint activities"
      end
    end

    task categories: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Categories #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::CategoryImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{Category.count} categories"
      end
    end

    task constellations: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Constellations #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::ConstellationImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{Constellation.count} constellations"
      end
    end

    task corporations: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Corporations #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::CorporationImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{Corporation.count} corporations"
      end
    end

    task dogma_attributes: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Dogma Attributes #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::DogmaAttributeImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{DogmaAttribute.count} dogma attributes"
      end
    end

    task dogma_categories: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Dogma Categories #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::DogmaCategoryImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{DogmaCategory.count} dogma categories"
      end
    end

    task dogma_effects: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Dogma Effects #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::DogmaEffectImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{DogmaEffect.count} dogma effects"
      end
    end

    task dogma_effect_modifiers: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Dogma Effect Modifiers #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::DogmaEffectModifierImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{DogmaEffectModifier.count} dogma effect modifiers"
      end
    end

    task factions: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Factions #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::FactionImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{Faction.count} factions"
      end
    end

    task graphics: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Graphics #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::GraphicImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{Graphic.count} graphics"
      end
    end

    task groups: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Groups #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::GroupImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{Group.count} groups"
      end
    end

    task icons: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Icons #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::IconImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{Icon.count} icons"
      end
    end

    task market_groups: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Market Groups #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::MarketGroupImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{MarketGroup.count} market groups"
      end
    end

    task meta_groups: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Meta Groups #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::MetaGroupImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{MetaGroup.count} meta groups"
      end
    end

    task planet_schematics: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Planet Schematics #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::PlanetSchematicImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{PlanetSchematic.count} planet schematics"
      end
    end

    task races: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Races #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::RaceImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{Race.count} races"
      end
    end

    task regions: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Regions #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::RegionImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{Region.count} regions"
      end
    end

    task solar_systems: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Solar Systems #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::SolarSystemImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{SolarSystem.count} solar systems"
      end
    end

    task station_operations: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Stations #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::StationOperationImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{StationOperation.count} station operations"
      end
    end

    task station_services: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Stations #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::StationServiceImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{StationService.count} station services"
      end
    end

    task types: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Types #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::TypeImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{Type.count} types"
      end
    end

    task type_materials: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Type Materials #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::TypeMaterialImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{TypeMaterial.count} type materials"
      end
    end

    task units: :environment do
      Logidze.with_responsible(ENV.fetch('SDE_VERSION_ID')) do
        progress = TTY::ProgressBar.new("Units #{IMPORT_PROGRESS_FORMAT}")
        Jove::SDE::Importers::UnitImporter.new(sde_path: SDE_PATH, progress:).import_all
        puts "Imported #{Unit.count} units"
      end
    end

    task areas: %i[regions constellations solar_systems]

    task dogma: %i[dogma_attributes dogma_effects dogma_effect_modifiers dogma_categories]

    task entities: %i[races bloodlines corporations factions]

    task images: %i[graphics icons]

    task industry: %i[blueprint_activities type_materials planet_schematics]

    task structures: %i[stargates]

    task taxonomies: %i[categories groups market_groups meta_groups units]

    task universe: %i[areas structures entities taxonomies types images stations station_operations
                      station_services]
  end
end
