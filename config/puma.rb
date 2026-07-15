# frozen_string_literal: true

# One file per RACK_ENV under config/puma/ (same env names as config/rack/ and config.ru).

env = ENV.fetch('RACK_ENV', 'development')
path = File.expand_path(File.join('puma', "#{env}.rb"), __dir__)

unless File.file?(path)
  raise LoadError,
        "No Puma config for RACK_ENV=#{env.inspect} (expected #{path}). " \
        'Valid values: development, test, staging, production.'
end

instance_eval(File.read(path), path)
