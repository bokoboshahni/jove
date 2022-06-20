# frozen_string_literal: true

set :stage, :production
set :rails_env, :production

set :branch, `git branch` =~ /\* (\S+)\s/m ? Regexp.last_match(1) : ENV.fetch('DEPLOY_BRANCH', 'main')
