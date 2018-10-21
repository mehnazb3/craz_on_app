class Abuse < ApplicationRecord
  include CommonModelMethods

  module AbusableItem
    LIST = [MicroBlog, Comment, Share].map(&:name).map(&:underscore)
  end

  module Pagination
    PER_PAGE = 10
  end

  # Associations
  belongs_to :abusable_item, polymorphic: true
  belongs_to :user
  belongs_to :location

  # Validations

  # Scopes
  scope :unhandled, -> {  where(has_been_handled: false) }
  scope :confirmed, -> { where(is_confirmed: true) }
  scope :rejected, -> { where(is_confirmed: false, has_been_handled: true ) }
  scope :filter_by_item_type, -> (item_type) { where(abusable_item_type: item_type ) }

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
    self.update_column(:has_been_handled, true)
    self.update_column(:is_confirmed, confirm_status)
    self.abusable_item.abuse_record
  end
end
