class Like < ApplicationRecord
  include CommonModelMethods

  module ListBy
    ITEMS = [MicroBlog, Comment, Share].map(&:name).map(&:underscore)
  end

  # Associations
  belongs_to :user
  belongs_to :location
  belongs_to :likable_item, polymorphic: true
end
