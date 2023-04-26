class Subscription < ApplicationRecord
  belongs_to :user

  validates :plan_id, :customer_id, :status, :current_period_end, :current_period_start, :interval, :subscription_id
end
