# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'pundit/rspec'
require 'pundit/matchers'
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

  config.before(:each, type: :component) do
    @request = controller.request
  end

  config.after(:each, type: :component, snapshot: true) do
    class_name = example.metadata[:described_class].name.underscore
    test_name = example.metadata[:full_description].gsub(example.metadata[:described_class].name, '').gsub(' ', '_')
    raise 'Component snapshot has no content' if rendered_component.blank?

    expect(rendered_component).to match_snapshot("#{class_name}/#{test_name}")
  end
end
