class Follow < ApplicationRecord
  # Associations
  
  belongs_to :followed, class_name: 'User'

  # Validations
  validates_presence_of :follower_id, :followed_id
  validates_numericality_of :follower_id, :followed_id
end
