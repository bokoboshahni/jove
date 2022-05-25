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

    task constellations: :environment do
      progress = TTY::ProgressBar.new("Constellations #{IMPORT_PROGRESS_FORMAT}")
      results = Constellation.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} constellations"
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

    task stars: :environment do
      progress = TTY::ProgressBar.new("Stars #{IMPORT_PROGRESS_FORMAT}")
      results = Star.import_all_from_sde(progress:)
      puts "Imported #{results.rows.count} stars"
    end

    task areas: %i[regions constellations solar_systems]

    task celestials: %i[stars secondary_suns planets moons asteroid_belts]

    task universe: %i[areas celestials]
  end
end
