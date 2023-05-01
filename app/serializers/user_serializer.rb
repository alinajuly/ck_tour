class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :email, :created_at, :updated_at, :password_digest, :role
end
