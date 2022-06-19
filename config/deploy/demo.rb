# frozen_string_literal: true

set :stage, :demo
set :rails_env, 'production'

role :app, ENV.fetch('DEPLOY_DEMO_ROLES_APP', '').split(',')
role :web, ENV.fetch('DEPLOY_DEMO_ROLES_WEB', '').split(',')
role :db, ENV.fetch('DEPLOY_DEMO_ROLES_DB', '').split(',')
role :worker, ENV.fetch('DEPLOY_DEMO_ROLES_WORKER', '').split(',')

set :application, ENV.fetch('DEPLOY_DEMO_APPLICATION', 'jove')
set :repo_url, ENV.fetch('DEPLOY_DEMO_REPO_URL', 'https://github.com/bokoboshahni/jove.git')
set :deploy_to, ENV.fetch('DEPLOY_DEMO_DIR', '/var/www/jove')

set :sidekiq_processes, ENV.fetch('DEPLOY_DEMO_SIDEKIQ_PROCESSES', 1).to_i
set :sidekiq_concurrency, ENV.fetch('DEPLOY_DEMO_SIDEKIQ_CONCURRENCY', 20).to_i

set :branch, Regexp.last_match(1) if `git branch` =~ /\* (\S+)\s/m
