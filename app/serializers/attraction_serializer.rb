class AttractionSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :description, :image, :image_url
end
