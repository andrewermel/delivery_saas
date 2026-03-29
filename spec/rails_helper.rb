# spec/rails_helper.rb
# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'devise'

# Load support files
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Fixture path
  config.fixture_path = [ Rails.root.join('spec/fixtures') ]

  # Use transactional fixtures
  config.use_transactional_fixtures = true

  # Infer spec type from file location
  config.infer_spec_type_from_file_location!

  # Filter Rails gems from backtraces
  config.filter_rails_from_backtrace!

  # FactoryBot syntax
  config.include FactoryBot::Syntax::Methods

  # Devise helpers
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers

  # Warden test mode
  config.before(:suite) { Warden.test_mode! }
  config.after(:each) { Warden.test_reset! }

  # Set devise mapping for controller tests automatically
  config.before(:each, type: :controller) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  # Include Devise helpers for request specs
  config.include Devise::Test::IntegrationHelpers, type: :request

  # Optional: clean database before each test if not using transactional fixtures
  # config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }
  # config.before(:each) { DatabaseCleaner.strategy = :transaction }
  # config.before(:each) { DatabaseCleaner.start }
  # config.after(:each) { DatabaseCleaner.clean }
end
