namespace :deploy do
  task :restart do
    on roles(:app) do
      within release_path do
        with api_env: fetch(:stage) do
          rack_pid_path = "#{shared_path}/tmp/pids/rack.pid"
          if test("[ -f #{rack_pid_path} ]")
            execute "kill $(cat #{rack_pid_path})"
          end

          execute :bundle, "exec rackup -D -P #{rack_pid_path}"
        end
      end
    end
  end
end

after 'deploy:publishing', 'deploy:restart'
