class AttractionSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :description, :image, :created_at, :updated_at, :image_url
end
