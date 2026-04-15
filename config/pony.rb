pony_config = ERB.new(File.read('config/pony.yml.erb')).result
pony_options = YAML.safe_load(pony_config, aliases: true)

rack_env = ENV.fetch('RACK_ENV', 'development')

Pony.options = pony_options.fetch(rack_env).deep_symbolize_keys

Pony.subject_prefix(APP_SECRETS[:mailer][:subject_prefix])
