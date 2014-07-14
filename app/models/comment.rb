class Comment < ActiveRecord::Base
  attr_accessible :content, :micropost_id, :user_id
  belongs_to :micropost
  belongs_to :user

  validates :user_id, presence: true
  validates :micropost_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  default_scope order: 'comments.created_at DESC'
end
