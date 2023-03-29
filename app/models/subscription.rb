class Subscription < ApplicationRecord
  belongs_to :customer
  belongs_to :price
  has_one :product, through: :price
end
