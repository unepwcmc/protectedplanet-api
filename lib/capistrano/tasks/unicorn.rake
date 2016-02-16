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
      execute "cd #{current_path} ; bundle exec unicorn_rails -c config/unicorn.rb -D -E #{fetch(:rails_env)}"
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:web), in: :sequence, wait: 5 do
      execute "kill -s QUIT `cat #{shared_path}/tmp/pids/unicorn.pid` || :"
    end
  end
end
