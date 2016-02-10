Pony.options = YAML.load(
  ERB.new(File.read("config/pony.yml.erb")).result
)[$environment].deep_symbolize_keys!

