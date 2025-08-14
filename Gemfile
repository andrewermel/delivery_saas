source "https://rubygems.org"

# Rails
gem "rails", "~> 8.0.2"

# Database
gem "pg", "~> 1.1"

# Web server
gem "puma", ">= 5.0"

# Asset management
gem "propshaft"
gem "importmap-rails"

# Hotwire
gem "turbo-rails"
gem "stimulus-rails"

# JSON APIs
gem "jbuilder"

# Authentication
gem "devise"

# Caching / background jobs / cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Development & debugging
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

# Timezone
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  # Testing
  gem "rspec-rails", "~> 8.0"
  gem "factory_bot_rails"

  # Debugging
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  # Static analysis
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
