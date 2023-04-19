class GeolocationSerializer
  include JSONAPI::Serializer
  attributes :id, :locality, :latitude, :longitude, :street, :suite, :zip_code, :geolocationable_type, :geolocationable_id
end
