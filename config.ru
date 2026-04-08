# frozen_string_literal: true

require 'rack'
require_relative 'config/environment'

# One file per RACK_ENV under config/rack/ (same env names as config/puma/ and config.ru).

env = ENV.fetch('RACK_ENV', 'development')
path = File.expand_path(File.join('config', 'rack', "#{env}.rb"), __dir__)

unless File.file?(path)
  raise LoadError,
        "No Rack config for RACK_ENV=#{env.inspect} (expected #{path}). " \
        'Valid values: development, test, staging, production.'
end

instance_eval(File.read(path), path)
