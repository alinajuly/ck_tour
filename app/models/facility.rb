class Facility < ApplicationRecord
  belongs_to :accommodation
  jsonb_accessor :data,
                 credit_card: [:boolean, { default: false }],
                 free_parking: [:boolean, { default: false }],
                 wi_fi: [:boolean, { default: false }],
                 breakfast: [:boolean, { default: false }],
                 pets: [:boolean, { default: false }],
                 checkin_start: :datetime,
                 checkin_end: :datetime,
                 checkout_start: :datetime,
                 checkout_end: :datetime
end
