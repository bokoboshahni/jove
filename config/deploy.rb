# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.17.0'

Rake::Task['deploy:assets:backup_manifest'].clear_actions

SSHKit.config.command_map[:sidekiq] = 'bundle exec sidekiq'
SSHKit.config.command_map[:sidekiqctl] = 'bundle exec sidekiqctl'
SSHKit.config.umask = '022'

role :app, ENV.fetch('DEPLOY_ROLES_APP', '').split(',')
role :web, ENV.fetch('DEPLOY_ROLES_WEB', '').split(',')
role :db, ENV.fetch('DEPLOY_ROLES_DB', '').split(',')
role :worker, ENV.fetch('DEPLOY_ROLES_WORKER', '').split(',')

set :application, ENV.fetch('DEPLOY_APPLICATION', 'jove')
set :repo_url, ENV.fetch('DEPLOY_REPO_URL', 'https://github.com/bokoboshahni/jove.git')
set :branch, ENV.fetch('DEPLOY_BRANCH', 'main')
set :deploy_to, ENV.fetch('DEPLOY_DIR', '/var/www/jove')

set :rbenv_type, :user
set :rbenv_ruby, '3.1.2'

set :migration_role, :app

set :assets_roles, %i[app]
set :keep_assets, 2

append :linked_files, '.env'
append :linked_dirs, 'log', 'tmp', 'vendor/bundle'

set :keep_releases, ENV.fetch('DEPLOY_KEEP_RELEASES', 1).to_i

set :puma_phased_restart, true
set :puma_systemctl_user, :user
set :puma_preload_app, true
set :puma_init_active_record, true

set :sidekiq_service_unit_user, :user
set :sidekiq_processes, ENV.fetch('SIDEKIQ_PROCESSES', 1).to_i
set :sidekiq_concurrency, ENV.fetch('SIDEKIQ_CONCURRENCY', 20).to_i
set :sidekiq_config, 'config/sidekiq.yml'

namespace :deploy do
  desc 'Load database schema from structure.sql'
  task :db_schema_load do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env), DISABLE_DATABASE_ENVIRONMENT_CHECK: '1' do
          execute :rake, 'db:schema:load'
        end
      end
    end
  end
end

before 'deploy:assets:precompile', 'deploy:db_schema_load' if ENV['DB_SCHEMA_LOAD']
