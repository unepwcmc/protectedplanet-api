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

  desc "Remove API users (inactive, archived, or archived_or_inactive)"
  task :remove, [:type] => :environment do |t, args|
    type = args[:type]&.downcase
    
    # Validate the type parameter
    unless type && ['inactive', 'archived', 'archived_or_inactive'].include?(type)
      if type.nil?
        puts "❌ Type parameter required"
      else
        puts "❌ Invalid type. Use: inactive, archived, or archived_or_inactive"
      end
      puts "Usage: rake api_users:remove[inactive]"
      puts "       rake api_users:remove[archived]" 
      puts "       rake api_users:remove[archived_or_inactive]"
      exit 1
    end

    # Build query based on type
    case type
    when 'inactive'
      users = ApiUser.where(active: false)
      description = "inactive"
    when 'archived'
      users = ApiUser.where(archived: true)
      description = "archived"
    when 'archived_or_inactive'
      users = ApiUser.where("active = false OR archived = true")
      description = "archived or inactive"
    end
    
    if users.empty?
      puts "No #{description} users found."
      exit
    end

    puts "Found #{users.count} #{description} users:"
    users.each do |user|
      status = []
      status << "inactive" if !user.active
      status << "archived" if user.archived
      status_text = status.any? ? " (#{status.join(', ')})" : ""
      
      timestamps = []
      timestamps << "created: #{user.created_at.strftime('%Y-%m-%d %H:%M')}"
      timestamps << "updated: #{user.updated_at.strftime('%Y-%m-%d %H:%M')}" if user.updated_at != user.created_at
      timestamps << "activated: #{user.activated_on.strftime('%Y-%m-%d %H:%M')}" if user.activated_on
      
      puts "  - #{user.email}#{status_text} - #{timestamps.join(', ')}"
    end

    print "\nAre you sure you want to delete these #{description} users? (yes/no): "
    confirmation = STDIN.gets.chomp.downcase

    if confirmation == 'yes'
      deleted_count = 0
      users.each do |user|
        user.destroy
        deleted_count += 1
        puts "Deleted user: #{user.email}"
      end
      puts "\n✅ Successfully deleted #{deleted_count} #{description} users."
    else
      puts "❌ Operation cancelled. No users were deleted."
    end
  end
end
