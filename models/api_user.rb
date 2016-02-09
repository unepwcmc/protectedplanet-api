class ApiUser < ActiveRecord::Base
  def activate!
    self.active = true
    save!

    refresh_token unless token
  end

  def refresh_token
    self.token = SecureRandom.hex(32)
    save
  end
end
