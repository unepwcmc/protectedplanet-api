workers 4
threads 4, 4

preload_app!

port 5000

daemonize
app_dir = File.expand_path("../..", __FILE__)
bind "unix://#{app_dir}/tmp/sockets/puma.sock"
stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true
pidfile "#{app_dir}/tmp/pids/puma.pid"
state_path "#{app_dir}tmp/pids/puma.state"
directory "#{app_dir}/"
activate_control_app "unix://#{app_dir}/tmp/sockets/pumactl.sock"
prune_bundler
