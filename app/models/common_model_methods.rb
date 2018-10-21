require 'active_support/concern'

module CommonModelMethods
  extend ActiveSupport::Concern

  included do
    # Scopes
    scope :viewable_users, -> (blocked_by_user_ids) {
      if blocked_by_user_ids.present?
        where( 'user_id NOT IN (?)', blocked_by_user_ids )
      else
        all
      end
    }
    scope :open_status, -> { where(status: 0)  }
    scope :abused_status, -> { where(status: 1) }

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
    self.update_column(:status, record_status)
    self.likes.update_all(status: record_status)
    self.comments.update_all(status: record_status)
    self.comments.map{|comment| comment.comments.update_all(status: record_status) }
    self.shares.update_all(status: record_status) if self.is_a?(MicroBlog)
  end

end