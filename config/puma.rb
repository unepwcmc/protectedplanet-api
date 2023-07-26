workers 2
threads 1, 2

preload_app!

port        5000
environment "staging"

app_dir = File.expand_path("../..", __FILE__)
bind "unix://#{app_dir}/tmp/puma/puma.sock"
stdout_redirect "#{app_dir}/logs/puma.stdout.log", "#{app_dir}/logs/puma.stderr.log", true
pidfile "#{app_dir}/tmp/puma/pid"
state_path "#{app_dir}/tmp/puma/state"
directory "#{app_dir}/"
activate_control_app "unix://#{app_dir}/tmp/puma/pumactl.sock"
prune_bundler