class CateringSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :kind, :phone, :places, :email, :reg_code, :address_owner, :person, :status
end
