class Comment < ApplicationRecord
  include CommonModelMethods

  module ListBy
    ITEMS = [MicroBlog, Comment, Share].map(&:name).map(&:underscore)
  end

  # Associations
  belongs_to :user
  belongs_to :commentable_item, polymorphic: true
  belongs_to :location
  has_many :likes, as: :likable_item
  has_many :comments, as: :commentable_item
  has_many :abuses, :as => :abusable_item, :dependent => :destroy, :class_name => 'Abuse'

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
