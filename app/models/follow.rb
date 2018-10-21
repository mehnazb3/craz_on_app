class Follow < ApplicationRecord
  # Associations
  belongs_to :follower, foreign_key: 'follower_id', class_name: 'User'
  belongs_to :following, foreign_key: 'followed_id', class_name: 'User'

  # Validations
  validates_presence_of :follower_id, :followed_id
  validates_numericality_of :follower_id, :followed_id
end
