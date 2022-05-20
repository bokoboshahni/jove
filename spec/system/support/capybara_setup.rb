# frozen_string_literal: true

Capybara.singleton_class.prepend(Module.new do
  attr_accessor :last_used_session

  def using_session(name, &)
    self.last_used_session = name
    super
  ensure
    self.last_used_session = nil
  end
end)

Capybara.default_max_wait_time = 5
Capybara.default_normalize_ws = true
Capybara.save_path = ENV.fetch('CAPYBARA_ARTIFACTS', './tmp/capybara')

# Make server accessible from the outside world
Capybara.server_host = '0.0.0.0'
# Use a hostname that could be resolved in the internal Docker network
Capybara.app_host = "http://#{ENV.fetch('APP_HOST', `hostname`.strip&.downcase || '0.0.0.0')}"
