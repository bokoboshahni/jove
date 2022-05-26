# frozen_string_literal: true

require 'sidekiq/throttled'
Sidekiq::Throttled.setup!

SidekiqUniqueJobs.configure do |config|
  config.enabled = !Rails.env.test?
  config.lock_info = true
end

Sidekiq.strict_args!

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('SIDEKIQ_REDIS_URL', 'redis://localhost:6379/1'), driver: :hiredis }

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end

  config.server_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Server
  end

  SidekiqUniqueJobs::Server.configure(config)
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('SIDEKIQ_REDIS_URL', 'redis://localhost:6379/1'), driver: :hiredis }

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end
end

require 'sidekiq/web'
require 'sidekiq-scheduler/web'
require 'sidekiq/throttled/web'
require 'sidekiq_unique_jobs/web'
