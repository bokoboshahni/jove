# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.1'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.2', '>= 7.0.2.3'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem 'tailwindcss-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
gem 'kredis'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

gem 'rack-mini-profiler'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

gem 'view_component', '~> 2.51'

gem 'local_time', '~> 2.1'

gem 'annotate', '~> 3.2', group: :development
gem 'erb_lint', '~> 0.1.1', group: :development
gem 'rubocop', '~> 1.26', group: :development
gem 'rubocop-performance', '~> 1.13', group: :development
gem 'rubocop-rails', '~> 2.14', group: :development

gem 'better_html', '~> 1.0'

gem 'capybara', '~> 3.36', group: :test
gem 'rspec-rails', '~> 5.1', group: :test
gem 'selenium-webdriver', '~> 4.1', group: :test
gem 'simplecov', '~> 0.21.2', group: :test
gem 'vcr', '~> 6.1', group: :test
gem 'webmock', '~> 3.14', group: :test

gem 'i18n-tasks', '~> 0.9.37', groups: %i[development test]

gem 'brakeman', '~> 5.2', group: :development

gem 'flamegraph', '~> 0.9.5'
gem 'memory_profiler', '~> 1.0'
gem 'stackprof', '~> 0.2.19'

gem 'awesome_print', '~> 1.9'
gem 'pry-rails', '~> 0.3.9'

gem 'dotenv-rails', '~> 2.7'

gem 'hiredis', '~> 0.6.3'
gem 'oj', '~> 3.13'

gem 'rubocop-rspec', '~> 2.9', group: :development
