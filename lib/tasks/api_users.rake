require 'models/api_user'

namespace :api_users do
  desc "Reset permissions for all users"
  task :reset_permissions => :environment do
    ApiUser.all.each { |user|
      user.send(:set_permissions)
      user.save
      puts "Permissions reset for #{user.email}"
    }
  end
end
