class Block < ApplicationRecord
  # Associations
  belongs_to :blocker, class_name: 'User'
  belongs_to :blocked, class_name: 'User'

  # Validations
  validates_presence_of :blocker_id, :blocked_id
  validates_numericality_of :blocker_id, :blocked_id

  # Callbacks
  after_save :unfollow_user

  # Callback methods
  def unfollow_user
    blocker.unfollow(blocked_id) if blocker.follows?(blocked_id)
    blocked.unfollow(blocker_id) if blocked.follows?(blocker_id)
  end
end
