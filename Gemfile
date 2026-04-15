source 'https://rubygems.org'

ruby '4.0.2'

# We can't upgrade to dotenv 3.2 until we upgrade kamal v2
gem 'dotenv', '~> 2.8'

# Frameworks
gem 'grape', '~> 3.2'
gem 'grape_logging', '~> 3.0'
gem 'kaminari', '~> 1.2'
gem 'kramdown', '~> 2.4'
gem 'sinatra', '~> 4.2'

# Security
gem 'rack-cors', '~> 3.0', require: 'rack/cors'
gem 'rack_csrf', '~> 2.7'

# Database
gem 'activerecord', '~> 8.1.0'
gem 'activerecord-postgis-adapter', '~> 11.1'
gem 'pg', '~> 1.6'

# Notifications
gem 'exception_notification', '~> 5.0'
gem 'pony', '~> 1.13'
gem 'slack-notifier', '~> 2.4'

# Analytics
gem 'appsignal', '~> 4.8'

# Support
gem 'activesupport', '~> 8.1.0'
gem 'csv', '~> 3.3'
gem 'rake', '~> 13.2'
gem 'webrick', '~> 1.9'

# Deployment & Server
gem 'kamal', '~> 1.9'
gem 'puma', '~> 8.0'

# Testing
group :test, :development do
  gem 'database_cleaner-active_record', '~> 2.2'
  gem 'factory_bot', '~> 6.4'
  gem 'minitest', '~> 6.0'
  gem 'rack-test', '~> 2.1'
  gem 'simplecov', '~> 0.22', require: false
end

group :development do
  gem 'debug', '~> 1.10'
  gem 'rubocop', '~> 1.86', require: false
end
