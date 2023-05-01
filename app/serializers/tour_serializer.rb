class TourSerializer
  include JSONAPI::Serializer
  attributes :title, :description, :person, :phone, :email, :seats, :time_start, :time_end, :reg_code, :address_owner, :price_per_one
end
