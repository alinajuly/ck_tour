class User < ApplicationRecord
  require 'securerandom'
  has_many :accommodations, dependent: :destroy
  has_many :tours, dependent: :destroy
  has_many :caterings, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :appointments, dependent: :destroy

  before_validation :ensure_stripe_customer

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



  enum role: { tourist: 0, partner: 1, admin: 2 }

  scope :role_filter, ->(role) { where(role: role) }

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!(validate: false)
  end

  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!(validate: false)
  end

  def stripe_attributes(pay_customer)
    attrs = {
      description: 'Created with pay',
      metadata: {
        pay_customer_id: pay_customer.id,
        user_id: id
      }
    }

    attrs
  end

  def ensure_stripe_customer
    response = Stripe::Customer.create(email: email)
    self.stripe_id = response.id
  end

  # to retrieve all the Stripe info for user
  def retrieve_stripe_reference
    Stripe::Customer.retrieve(stripe_id)
  end

  private

  def generate_token
    SecureRandom.hex(10)
  end
end
