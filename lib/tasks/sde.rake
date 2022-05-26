# frozen_string_literal: true

IMPORT_PROGRESS_FORMAT = '[:bar] :current/:total :percent ET::elapsed ETA::eta :rate/s'

namespace :sde do # rubocop:disable Metrics/BlockLength
  task clean: :environment do
    FileUtils.rm_rf(Rails.root.join('tmp/sde'))
    FileUtils.rm_f(Rails.root.join('tmp/sde.zip'))
  end

  task download: :environment do
    sde_file = Rails.root.join('tmp/sde.zip')
    Down.download(Jove.config.sde_zip_url, destination: sde_file)
    Dir.chdir(Rails.root.join('tmp')) { system('unzip sde.zip') }
  end

  task fixtures: :environment do
    require 'jove/sde/fixtures'
    Jove::SDE::Fixtures.new.generate
  end

  namespace :import do # rubocop:disable Metrics/BlockLength
    task asteroid_belts: :environment do
      progress = TTY::ProgressBar.new("Asteroid Belts #{IMPORT_PROGRESS_FORMAT}")
      results = AsteroidBelt.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} asteroid belts"
    end

    task bloodlines: :environment do
      progress = TTY::ProgressBar.new("Bloodlines #{IMPORT_PROGRESS_FORMAT}")
      results = Bloodline.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} bloodlines"
    end

    task blueprints: :environment do
      progress = TTY::ProgressBar.new("Blueprints #{IMPORT_PROGRESS_FORMAT}")
      results = BlueprintActivity.import_all_from_sde(progress:)
      puts "Imported #{results} blueprints"
    end

    task categories: :environment do
      progress = TTY::ProgressBar.new("Categories #{IMPORT_PROGRESS_FORMAT}")
      results = Category.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} categories"
    end

    task constellations: :environment do
      progress = TTY::ProgressBar.new("Constellations #{IMPORT_PROGRESS_FORMAT}")
      results = Constellation.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} constellations"
    end

    task corporations: :environment do
      progress = TTY::ProgressBar.new("Corporations #{IMPORT_PROGRESS_FORMAT}")
      results = Corporation.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} corporations"
    end

    task factions: :environment do
      progress = TTY::ProgressBar.new("Factions #{IMPORT_PROGRESS_FORMAT}")
      results = Faction.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} factions"
    end

    task graphics: :environment do
      progress = TTY::ProgressBar.new("Graphics #{IMPORT_PROGRESS_FORMAT}")
      results = Graphic.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} graphics"
    end

    task groups: :environment do
      progress = TTY::ProgressBar.new("Groups #{IMPORT_PROGRESS_FORMAT}")
      results = Group.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} groups"
    end

    task icons: :environment do
      progress = TTY::ProgressBar.new("Icons #{IMPORT_PROGRESS_FORMAT}")
      results = Icon.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} icons"
    end

    task market_groups: :environment do
      progress = TTY::ProgressBar.new("Market Groups #{IMPORT_PROGRESS_FORMAT}")
      results = MarketGroup.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} market groups"
    end

    task meta_groups: :environment do
      progress = TTY::ProgressBar.new("Meta Groups #{IMPORT_PROGRESS_FORMAT}")
      results = MetaGroup.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} meta groups"
    end

    task moons: :environment do
      progress = TTY::ProgressBar.new("Moons #{IMPORT_PROGRESS_FORMAT}")
      results = Moon.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} moons"
    end

    task planets: :environment do
      progress = TTY::ProgressBar.new("Planets #{IMPORT_PROGRESS_FORMAT}")
      results = Planet.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} planets"
    end

    task races: :environment do
      progress = TTY::ProgressBar.new("Races #{IMPORT_PROGRESS_FORMAT}")
      results = Race.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} races"
    end

    task regions: :environment do
      progress = TTY::ProgressBar.new("Regions #{IMPORT_PROGRESS_FORMAT}")
      results = Region.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} regions"
    end

    task secondary_suns: :environment do
      progress = TTY::ProgressBar.new("Secondary Suns #{IMPORT_PROGRESS_FORMAT}")
      results = SecondarySun.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} secondary suns"
    end

    task solar_systems: :environment do
      progress = TTY::ProgressBar.new("Solar Systems #{IMPORT_PROGRESS_FORMAT}")
      results = SolarSystem.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} solar systems"
    end

    task stargates: :environment do
      progress = TTY::ProgressBar.new("Stargates #{IMPORT_PROGRESS_FORMAT}")
      results = Stargate.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} stargates"
    end

    task stars: :environment do
      progress = TTY::ProgressBar.new("Stars #{IMPORT_PROGRESS_FORMAT}")
      results = Star.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} stars"
    end

    task stations: :environment do
      progress = TTY::ProgressBar.new("Stations #{IMPORT_PROGRESS_FORMAT}")
      results = Station.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} stations"
    end

    task station_operations: :environment do
      progress = TTY::ProgressBar.new("Stations #{IMPORT_PROGRESS_FORMAT}")
      results = StationOperation.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} station operations"
    end

    task station_services: :environment do
      progress = TTY::ProgressBar.new("Stations #{IMPORT_PROGRESS_FORMAT}")
      results = StationService.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} station services"
    end

    task types: :environment do
      progress = TTY::ProgressBar.new("Types #{IMPORT_PROGRESS_FORMAT}")
      results = Type.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} types"
    end

    task areas: %i[regions constellations solar_systems]

    task celestials: %i[stars secondary_suns planets moons asteroid_belts]

    task entities: %i[races bloodlines corporations factions]

    task images: %i[graphics icons]

    task industry: %i[blueprints]

    task structures: %i[stargates]

    task taxonomies: %i[categories groups market_groups meta_groups]

    task universe: %i[areas celestials structures entities taxonomies types images stations station_operations
                      station_services]
  end
end
