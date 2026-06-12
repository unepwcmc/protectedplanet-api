Appsignal.configure do |config|
  config.activate_if_environment(:development, :staging, :production)
  config.log = 'stdout'
end
