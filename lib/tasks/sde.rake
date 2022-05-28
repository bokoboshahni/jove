# frozen_string_literal: true

IMPORT_PROGRESS_FORMAT = '[:bar] :current/:total :percent ET::elapsed ETA::eta :rate/s'

namespace :sde do # rubocop:disable Metrics/BlockLength
  task clean: :environment do
    FileUtils.rm_rf(Rails.root.join('tmp/sde'))
    FileUtils.rm_f(Rails.root.join('tmp/sde.zip'))
  end

  task download: :environment do
    sde_file = Rails.root.join('tmp/sde.zip')
    Down.download(Jove.config.sde_archive_url, destination: sde_file)
    Dir.chdir(Rails.root.join('tmp')) { system('unzip sde.zip') }
  end

  task fixtures: :environment do
    require 'jove/sde/fixtures'
    Jove::SDE::Fixtures.new.generate
  end

  namespace :import do # rubocop:disable Metrics/BlockLength
    task asteroid_belts: :environment do
      progress = TTY::ProgressBar.new("Asteroid Belts #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::AsteroidBeltImporter.new(
        sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')), progress:
      ).import_all
      puts "Imported #{results.rows.count} asteroid belts"
    end

    task bloodlines: :environment do
      progress = TTY::ProgressBar.new("Bloodlines #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::BloodlineImporter.new(
        sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')), progress:
      ).import_all
      puts "Imported #{results.rows.count} bloodlines"
    end

    task blueprints: :environment do
      progress = TTY::ProgressBar.new("Blueprints #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::BlueprintActivityImporter.new(
        sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')), progress:
      ).import_all
      puts "Imported #{results} blueprints"
    end

    task categories: :environment do
      progress = TTY::ProgressBar.new("Categories #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::CategoryImporter.new(sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')),
                                                           progress:).import_all
      puts "Imported #{results.rows.count} categories"
    end

    task constellations: :environment do
      progress = TTY::ProgressBar.new("Constellations #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::ConstellationImporter.new(
        sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')), progress:
      ).import_all
      puts "Imported #{results.rows.count} constellations"
    end

    task corporations: :environment do
      progress = TTY::ProgressBar.new("Corporations #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::CorporationImporter.new(
        sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')), progress:
      ).import_all
      puts "Imported #{results.rows.count} corporations"
    end

    task dogma_attributes: :environment do
      progress = TTY::ProgressBar.new("Dogma Attributes #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::DogmaAttributeImporter.new(
        sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')), progress:
      ).import_all
      puts "Imported #{results.rows.count} dogma attributes"
    end

    task dogma_categories: :environment do
      progress = TTY::ProgressBar.new("Dogma Categories #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::DogmaCategoryImporter.new(
        sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')), progress:
      ).import_all
      puts "Imported #{results.rows.count} dogma categories"
    end

    task dogma_effects: :environment do
      progress = TTY::ProgressBar.new("Dogma Effects #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::DogmaEffectImporter.new(
        sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')), progress:
      ).import_all
      puts "Imported #{results.rows.count} dogma effects"
    end

    task dogma_effect_modifiers: :environment do
      progress = TTY::ProgressBar.new("Dogma Effect Modifiers #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::DogmaEffectModifierImporter.new(
        sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')), progress:
      ).import_all
      puts "Imported #{results.rows.count} dogma effect modifiers"
    end

    task factions: :environment do
      progress = TTY::ProgressBar.new("Factions #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::FactionImporter.new(sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')),
                                                          progress:).import_all
      puts "Imported #{results.rows.count} factions"
    end

    task graphics: :environment do
      progress = TTY::ProgressBar.new("Graphics #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::GraphicImporter.new(sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')),
                                                          progress:).import_all
      puts "Imported #{results.rows.count} graphics"
    end

    task groups: :environment do
      progress = TTY::ProgressBar.new("Groups #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::GroupImporter.new(sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')),
                                                        progress:).import_all
      puts "Imported #{results.rows.count} groups"
    end

    task icons: :environment do
      progress = TTY::ProgressBar.new("Icons #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::IconImporter.new(sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')),
                                                       progress:).import_all
      puts "Imported #{results.rows.count} icons"
    end

    task market_groups: :environment do
      progress = TTY::ProgressBar.new("Market Groups #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::MarketGroupImporter.new(
        sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')), progress:
      ).import_all
      puts "Imported #{results.rows.count} market groups"
    end

    task meta_groups: :environment do
      progress = TTY::ProgressBar.new("Meta Groups #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::MetaGroupImporter.new(
        sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')), progress:
      ).import_all
      puts "Imported #{results.rows.count} meta groups"
    end

    task moons: :environment do
      progress = TTY::ProgressBar.new("Moons #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::MoonImporter.new(sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')),
                                                       progress:).import_all
      puts "Imported #{results.rows.count} moons"
    end

    task planet_schematics: :environment do
      progress = TTY::ProgressBar.new("Planet Schematics #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::PlanetSchematicImporter.new(
        sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')), progress:
      ).import_all
      puts "Imported #{results.rows.count} planet schematics"
    end

    task planets: :environment do
      progress = TTY::ProgressBar.new("Planets #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::PlanetImporter.new(sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')),
                                                         progress:).import_all
      puts "Imported #{results.rows.count} planets"
    end

    task races: :environment do
      progress = TTY::ProgressBar.new("Races #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::RaceImporter.new(sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')),
                                                       progress:).import_all
      puts "Imported #{results.rows.count} races"
    end

    task regions: :environment do
      progress = TTY::ProgressBar.new("Regions #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::RegionImporter.new(sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')),
                                                         progress:).import_all
      puts "Imported #{results.rows.count} regions"
    end

    task secondary_suns: :environment do
      progress = TTY::ProgressBar.new("Secondary Suns #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::SecondarySunImporter.new(
        sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')), progress:
      ).import_all
      puts "Imported #{results.rows.count} secondary suns"
    end

    task solar_systems: :environment do
      progress = TTY::ProgressBar.new("Solar Systems #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::SolarSystemImporter.new(
        sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')), progress:
      ).import_all
      puts "Imported #{results.rows.count} solar systems"
    end

    task stargates: :environment do
      progress = TTY::ProgressBar.new("Stargates #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::StargateImporter.new(sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')),
                                                           progress:).import_all
      puts "Imported #{results.rows.count} stargates"
    end

    task stars: :environment do
      progress = TTY::ProgressBar.new("Stars #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::StarImporter.new(sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')),
                                                       progress:).import_all
      puts "Imported #{results.rows.count} stars"
    end

    task stations: :environment do
      progress = TTY::ProgressBar.new("Stations #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::StationImporter.new(sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')),
                                                          progress:).import_all
      puts "Imported #{results.rows.count} stations"
    end

    task station_operations: :environment do
      progress = TTY::ProgressBar.new("Stations #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::StationOperationImporter.new(
        sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')), progress:
      ).import_all
      puts "Imported #{results.rows.count} station operations"
    end

    task station_services: :environment do
      progress = TTY::ProgressBar.new("Stations #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::StationServiceImporter.new(
        sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')), progress:
      ).import_all
      puts "Imported #{results.rows.count} station services"
    end

    task types: :environment do
      progress = TTY::ProgressBar.new("Types #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::TypeImporter.new(sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')),
                                                       progress:).import_all
      puts "Imported #{results.rows.count} types"
    end

    task type_materials: :environment do
      progress = TTY::ProgressBar.new("Type Materials #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::TypeMaterialImporter.new(
        sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')), progress:
      ).import_all
      puts "Imported #{results.rows.count} type materials"
    end

    task units: :environment do
      progress = TTY::ProgressBar.new("Units #{IMPORT_PROGRESS_FORMAT}")
      results = Jove::SDE::Importers::UnitImporter.new(sde_path: ENV.fetch('SDE_PATH', Rails.root.join('tmp/sde')),
                                                       progress:).import_all
      puts "Imported #{results.rows.count} units"
    end

    task areas: %i[regions constellations solar_systems]

    task celestials: %i[stars secondary_suns planets moons asteroid_belts]

    task dogma: %i[dogma_attributes dogma_effects dogma_effect_modifiers dogma_categories]

    task entities: %i[races bloodlines corporations factions]

    task images: %i[graphics icons]

    task industry: %i[blueprints type_materials planet_schematics]

    task structures: %i[stargates]

    task taxonomies: %i[categories groups market_groups meta_groups units]

    task universe: %i[areas celestials structures entities taxonomies types images stations station_operations
                      station_services]
  end
end
