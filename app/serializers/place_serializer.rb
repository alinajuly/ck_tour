class PlaceSerializer
  include JSONAPI::Serializer
  attributes :name, :body
end
