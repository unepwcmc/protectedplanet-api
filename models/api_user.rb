class ApiUser < ActiveRecord::Base
  include Sinatra::Helpers

  before_validation :normalize_email_field
  before_create :set_permissions, :set_gdpr_consent

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, on: :request
  validates :full_name, :reason, presence: true, on: :request

  scope :pending, -> { where(active: false, archived: [false, nil]) }
  scope :active_accounts, -> { where(active: true, archived: [false, nil]) }

  def self.normalize_email(email)
    email.to_s.downcase.strip
  end

  def self.active_user_for_email(email)
    active_accounts
      .where("lower(email) = ?", normalize_email(email))
      .order(created_at: :desc)
      .first
  end

  def self.pending_user_for_email(email)
    pending
      .where("lower(email) = ?", normalize_email(email))
      .order(created_at: :desc)
      .first
  end

  def activate!
    return if self.active

    self.update_attribute(:activated_on, DateTime.now)
    self.update_attribute(:active, true)
    refresh_token unless token
  end

  def deactivate!
    self.update_attribute(:active, false)
  end

  def refresh_token
    self.token = SecureRandom.hex
    save
  end

  def self.new_token
    SecureRandom.hex
  end

  def access_to?(api_object, attribute)
    return false if self.permissions.nil?

    object_name = if api_object.is_a?(Class)
      api_object.name
    else
      api_object.class.name
    end

    self.permissions[object_name]&.include?(attribute.to_s)
  end

  private

  def normalize_email_field
    self.email = self.class.normalize_email(email) if email.present?
  end

  def set_permissions
    self.permissions ||= {}

    $api_objects.each do |api_object|
      object_name = api_object.is_a?(Class) ? api_object.name : api_object.to_s
      self.permissions[object_name] ||= api_object.api_attributes
    end
  end

  def set_gdpr_consent
    self.gdpr_consent = true
    self.gdpr_check_due = DateTime.now.next_year
  end
end
