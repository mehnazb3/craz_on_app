class Location < ApplicationRecord
  include CommonModelMethods

  module ListBy
    ITEMS = [MicroBlog, Like, Comment, Share, User].map(&:name).map(&:underscore)
  end

  # Associations
  has_many :users
  has_many :micro_blogs
  has_many :likes
  has_many :comments
  has_many :shares
  has_many :abuses

  # Validations
  validates_presence_of :name
end
