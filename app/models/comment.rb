class Comment < ApplicationRecord
  include CommonModelMethods

  module ListBy
    ITEMS = [MicroBlog, Comment, Share].map(&:name).map(&:underscore)
  end

  # Associations

  # Validations

  # Callbacks
  before_create :mark_reply_comment

  # Validation methods
  def cannot_reply_to_a_comment_more_than_one_level
  end

  # Callback methods
  def mark_reply_comment
    is_a_reply = commentable_item.is_a?(Comment)
  end
end
