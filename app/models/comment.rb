class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  enum status: { unpublished: 0, published: 1 }

  validates :user_id, presence: true
  validates :body, presence: true, length: { minimum: 5, message: 'Comment must contain 5 characters at least' }
end
