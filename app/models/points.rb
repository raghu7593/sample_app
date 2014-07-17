class Points < ActiveRecord::Base
  attr_accessible :activity, :score, :user_id
  belongs_to :user

  validates :user_id, presence: true
end
