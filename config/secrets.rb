secrets_config = ERB.new(File.read("config/secrets.yml.erb")).result
secrets_data = YAML.safe_load(secrets_config, aliases: true)

APP_SECRETS = secrets_data.fetch(APP_ENV).deep_symbolize_keys.freeze

