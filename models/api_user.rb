class ApiUser < ActiveRecord::Base
  def activate!
    self.active = true
    save!

    refresh_token unless token
  end

  def deactivate!
    self.active = false
    save!
  end

  def refresh_token
    self.token = SecureRandom.hex
    save
  end

  def self.new_token
    SecureRandom.hex
  end
end
