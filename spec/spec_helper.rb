# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails' do
  add_group 'Components', 'app/components'
  add_group 'Filters', 'app/filters'
  add_group 'Finders', 'app/finders'
  add_group 'Forms', 'app/forms'
  add_group 'Jobs', 'app/jobs'
  add_group 'Policies', 'app/policies'
  add_group 'Repositories', 'app/repositories'
  add_group 'Services', 'app/services'
  add_group 'Workers', 'app/workers'

  add_filter(/_preview\.rb\z/)
  add_filter '/app/components/guidelines/'
  add_filter '/lib/generators/'

  enable_coverage :branch
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!

  config.default_formatter = 'doc' if config.files_to_run.one?
  config.example_status_persistence_file_path = 'tmp/examples.txt'
  config.order = :random
  config.profile_examples = 10
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
