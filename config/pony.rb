pony_config = ERB.new(File.read('config/pony.yml.erb')).result
pony_options = YAML.safe_load(pony_config, aliases: true)

Pony.options = pony_options.fetch(APP_ENV).deep_symbolize_keys
Pony.subject_prefix(APP_SECRETS[:mailer][:subject_prefix])
