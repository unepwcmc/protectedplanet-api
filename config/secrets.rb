$secrets = YAML.load(
  ERB.new(File.read("config/secrets.yml.erb")).result
)[$environment].deep_symbolize_keys!

