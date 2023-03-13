class User < ApplicationRecord
  require 'securerandom'

  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_PASSWORD_REGEX = /\A
  (?=.*\d)           # At least one digit
  (?=.*[a-z])        # At least one lowercase letter
  (?=.*[A-Z])        # At least one uppercase letter
  (?=.*[[:^alnum:]]) # At least one symbol
  [[:print:]]{8,}    # At least 8 printable characters
\z/x

  validates :email, presence: true, length: { minimum: 5, maximum: 255 }, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8, maximum: 255 }, format: { with: VALID_PASSWORD_REGEX }
  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 50 }

  def generate_password_reset_token
    payload = { user_id: id, exp: 1.hour.from_now.to_i }
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end
end
