class Amenity < ApplicationRecord
  belongs_to :room
  jsonb_accessor :data,
                 conditioner: [:boolean, { default: false }],
                 tv: [:boolean, { default: false }],
                 refrigerator: [:boolean, { default: false }],
                 kettle: [:boolean, { default: false }],
                 mv_owen: [:boolean, { default: false }],
                 hair_dryer: [:boolean, { default: false }],
                 nice_view: [:boolean, { default: false }],
                 inclusive: [:boolean, { default: false }]
end
