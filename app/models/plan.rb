class Plan < ApplicationRecord
  has_many :subscriptions

  validates :name, :stripe_price_id, :price_cents, presence: true
  validates :name, :stripe_price_id, uniqueness: true

  enum interval: { month: 0, year: 1 }
  
  before_validation :create_stripe_reference, on: :create

  def create_stripe_reference
    response = Stripe::Price.create({
      unit_amount: price_cents,
      currency: 'uah',
      recurring: { interval: interval, interval_count: interval_count },
      product_data: { name: name }
    })

    self.stripe_price_id = response.id
  end

  # To retrieve all the Stripe info for some plans
  def retrieve_stripe_reference
    Stripe::Price.retrieve(stripe_price_id)
  end
end
