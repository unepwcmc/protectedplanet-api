namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:web), in: :sequence, wait: 5 do
      invoke 'deploy:stop'
      invoke 'deploy:start'
    end
  end
  after :publishing, :restart

  desc 'Start application'
  task :start do
    on roles(:web), in: :sequence, wait: 5 do
      within release_path do
        with rack_env: fetch(:stage) do
          execute :bundle, "exec unicorn -c config/unicorn.rb -D -E #{fetch(:stage)}"
        end
      end
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:web), in: :sequence, wait: 5 do
      within release_path do
        execute "kill -s QUIT `cat #{shared_path}/tmp/pids/unicorn.pid` || :"
      end
    end
  end
end
