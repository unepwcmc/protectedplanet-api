namespace :bower do
  desc 'Copy repo to releases'
  task published: :install do
    on roles(:web) do
      within current_path do
        execute :bower, :install
      end
    end
  end
end

