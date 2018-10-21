require 'active_support/concern'

module CommonModelMethods
  extend ActiveSupport::Concern

  included do
    # Scopes
    scope :viewable_users, -> (blocked_by_user_ids) {  }
    scope :open_status, -> {  }
    scope :abused_status, -> {  }

    # Callbacks
    before_validation :set_location
  end

  def set_location
    self.location_id = self.user.location_id unless self.is_a?(Location)
  end

  def abuse_record
    update_record_status(Constants::Item::Status::ABUSED)
  end

  def destroy_record
    update_record_status(Constants::Item::Status::DELETED)
  end

  def is_status?(check_status = Constants::Item::Status::OPEN)
    self.status == check_status
  end

  def liked_by?(user_id)
    likes.exists?(user_id: user_id)
  end

  def update_record_status(record_status)
  end
end