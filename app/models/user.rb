class User < ApplicationRecord
  
  #
  #
  # Name Validation
  validates :name,
            presence: true,
            length: { maximum: 50 }

  #
  #
  # Email Validation
  before_save { self.email = email.downcase }
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\-.]+\.[a-z]+\z/i
  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  #
  #
  # Password
  has_secure_password
  validates :password,
            length: { minimum: 6 }

end
