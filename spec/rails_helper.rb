# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'paper_trail/frameworks/rspec'
require 'pundit/rspec'
require 'pundit/matchers'
require 'sidekiq/testing'
require 'webmock/rspec'
require 'vcr'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

VCR.configure do |config|
  config.ignore_localhost = true
  config.cassette_library_dir = Rails.root.join('spec/cassettes')
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

WebMock.disable_net_connect!(allow_localhost: true)

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config| # rubocop:disable Metrics/BlockLength
  config.include ActiveSupport::Testing::TimeHelpers
  config.include Capybara::RSpecMatchers, type: :component
  config.include Devise::Test::ControllerHelpers, type: :component
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include FactoryBot::Syntax::Methods
  config.include ViewComponent::TestHelpers, type: :component
  config.include Warden::Test::Helpers

  config.use_transactional_fixtures = true

  config.filter_rails_from_backtrace!
  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    hypertable_models = [
      MarketOrderSnapshot,
      MarketOrder
    ]

    hypertable_models.each do |klass|
      table_name = klass.table_name
      time_column = klass.hypertable_options[:time_column]

      if klass.try(:hypertable).present?
        ApplicationRecord.logger.info("Hypertable already created for '#{table_name}'")
        next
      end

      ApplicationRecord.connection.execute <<~SQL
        DROP TRIGGER IF EXISTS ts_insert_blocker ON #{table_name}
      SQL

      ApplicationRecord.connection.execute <<~SQL
        SELECT create_hypertable('#{table_name}', '#{time_column}')
      SQL
    end
  end

  config.before do |example|
    if example.metadata[:type] == :system
      Flipper.instance = Flipper.new(Flipper::Adapters::ActiveRecord.new)
      Flipper::Adapters::ActiveRecord::Feature.delete_all
      Flipper::Adapters::ActiveRecord::Gate.delete_all
    else
      Flipper.instance = Flipper.new(Flipper::Adapters::Memory.new)
    end
  end

  config.before do |_example|
    WebMock.reset!
  end

  config.around do |example|
    if example.metadata[:vcr]
      VCR.turn_on!
      example.run
      VCR.turn_off!
    else
      VCR.turn_off!
      example.run
      VCR.turn_on!
    end
  end

  config.around do |example|
    if example.metadata[:search]
      example.run
    else
      PgSearch.disable_multisearch { example.run }
    end
  end

  config.before(:each, type: :component) do
    @request = controller.request
  end

  config.before(:each) do
    FileUtils.rm_rf(Rails.root.join('tmp/storage'))
    FileUtils.mkdir_p(Rails.root.join('tmp/storage'))
    FileUtils.touch(Rails.root.join('tmp/storage/.keep'))

    Sidekiq::Worker.clear_all
  end

  config.after(:each, type: :component, snapshot: true) do
    class_name = example.metadata[:described_class].name.underscore
    test_name = example.metadata[:full_description].gsub(example.metadata[:described_class].name, '').gsub(' ', '_')
    raise 'Component snapshot has no content' if rendered_component.blank?

    expect(rendered_component).to match_snapshot("#{class_name}/#{test_name}")
  end
end
