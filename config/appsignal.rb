Appsignal.configure do |config|
  config.activate_if_environment(:staging, :production)
end
