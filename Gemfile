source "https://rubygems.org"

# Frameworks
gem "grape", "~> 0.17.0"
gem "grape-rabl", "~> 0.4.1"
gem "grape-kaminari", "~> 0.1.8"
gem "grape_logging", '~> 1.3.0'
gem "sinatra", "~> 1.4.6"
gem "kramdown", "~> 1.9.0"

# Security
gem "rack_csrf", "~> 2.5.0"
gem "rack-cors", :require => "rack/cors"
gem "dotenv", "~> 2.1.0"

gem 'ed25519'
gem 'bcrypt_pbkdf'

# Database
gem "pg", "~> 0.18.4"
gem "activerecord", "~> 4.2.5"
gem "active_record_migrations", "~> 4.2.5.1.1", require: false
gem "activerecord-postgis-adapter", "~> 3.1.3"

# Notifications
gem "pony", "~> 1.11"
gem "slack-notifier", "~> 1.5.1"
gem "exception_notification", "~> 4.1.4"

# Analytics
gem "appsignal", "~> 1.1.0.beta.5"

# Support
gem "rake", "~> 10.5.0"
gem "activesupport", "~> 4.2.5"

# Testing
group :test, :development do
  gem "minitest"
  gem "minitest-around", "~> 0.3.2"
  gem "database_cleaner", "~> 1.5.1"
  gem "factory_girl", "~> 4.0"
  gem "rack-test", "~> 0.6.3"
end

# Deploy
group :development do
  gem 'capistrano', '~> 3.16.0', require: false
  gem 'capistrano-bundler', '~> 2.0.1', require: false
  gem 'capistrano-rvm',   '~> 0.1.2', require: false
  gem 'capistrano-maintenance', '~> 1.0', require: false
  gem 'capistrano-passenger', '~> 0.2.1', require: false
  gem 'byebug', '~> 3.1.2'
end
