require 'digest/sha1'
class User < ActiveRecord::Base
  validates_format_of :email, :with => /^(.+)@(.+)\.(.+)$/
  validates_uniqueness_of :email
  validates_length_of :password, :minimum => 4, :if => :password_required?

  # The virtual attributes that temporary stores the plain text passwords
  attr_accessor :password
  attr_accessor :password_confirmation

  # validates_confirmation_of allows nil. It also adds the error on the attribute it confirms,
  # not the virtual 'password_confirmation' attribute.
  validates_each(:password_confirmation, :if => :password_required?) do |record, attribute, value|
    record.errors.add(attribute) unless value == record.password
  end

  before_save :hash_password

  def self.authenticate(email, password)
    user = find_by_email(email)
    user && user.password_hash == hash_password(password, user.password_salt) && user
  end

  def valid_password?(password)
    password_hash == self.class.hash_password(password, self.password_salt)
  end

  private

  def self.hash_password(password, salt)
    Digest::SHA1.hexdigest(SETTINGS['salt_format'] % [password, salt])
  end

  def self.generate_salt
    Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join)
  end

  def hash_password
    if password_required?
      self.password_salt = self.class.generate_salt
      self.password_hash = self.class.hash_password(password, password_salt)
    end
  end

  def password_required?
    new_record? || !self.password.blank?
  end
end
