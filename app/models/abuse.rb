class Abuse < ApplicationRecord
  include CommonModelMethods

  module AbusableItem
    LIST = [MicroBlog, Comment, Share].map(&:name).map(&:underscore)
  end

  module Pagination
    PER_PAGE = 10
  end

  # Associations

  # Validations

  # Scopes
  scope :unhandled, -> {  }
  scope :confirmed, -> {  }
  scope :rejected, -> {  }
  scope :filter_by_item_type, -> (item_type) {  }

  # Callbacks
  after_update :confirm_abuse

  # Validation methods
  def should_confirm_or_not_when_handled
  end

  # Callback methods
  def confirm_abuse
  end

  # Instance methods
  def update_abuse_confirmation(confirm_status = false)
  end
end
