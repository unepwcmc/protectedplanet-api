namespace :deploy do
  task :restart do
    on roles(:app) do
      within release_path do
        with rack_env: fetch(:stage) do
          rack_pid_path = "#{shared_path}/tmp/pids/rack.pid"
          execute "kill $(cat #{rack_pid_path})" rescue nil

          execute :bundle, "exec rackup -D -P #{rack_pid_path}"
        end
      end
    end
  end
end

after 'deploy:publishing', 'deploy:restart'
