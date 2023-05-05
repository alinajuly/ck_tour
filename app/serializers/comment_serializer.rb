class CommentSerializer
  include JSONAPI::Serializer

  attributes :id, :body, :status, :created_at, :updated_at, :commentable_type, :commentable_id, :user_id, :name

  attribute :name do |comment|
    comment.user.name
  end
end
