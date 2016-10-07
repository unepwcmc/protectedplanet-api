require 'csv'

module AdminCsvGenerator
  def self.generate
    CSV.generate do |csv|
      csv << ["email", "token", "full_name", "company", "type", "has_license", "license_number", "reason", "active", "archived"]

      ApiUser.all.each do |user|
        csv << [
          user.email, user.token, user.full_name, user.company,
          user.kind, user.has_licence, user.licence_number,
          user.reason, user.active, user.archived
        ]
      end
    end
  end
end
