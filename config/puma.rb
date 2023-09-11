# We have switched back to Passenger, but leaving this here for reference
# and in case we need to switch back to Puma in the future.
# https://github.com/unepwcmc/protectedplanet-api/pull/58
workers 4
threads 4, 4

preload_app!

port 5000

app_dir = File.expand_path("../..", __FILE__)
bind "unix://#{app_dir}/tmp/sockets/puma.sock"
stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true
pidfile "#{app_dir}/tmp/pids/puma.pid"
state_path "#{app_dir}/tmp/pids/puma.state"
directory "#{app_dir}/"
activate_control_app "unix://#{app_dir}/tmp/sockets/pumactl.sock"
prune_bundler
