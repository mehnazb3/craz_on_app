class Share < ApplicationRecord
  include CommonModelMethods

  module ListBy
    ITEMS = [Like, Comment].map(&:name).map(&:underscore)
  end

  # Associations
  belongs_to :location
  belongs_to :user
  belongs_to :micro_blog
  has_many :comments, as: :commentable_item
  has_many :likes, as: :likable_item
  has_many :abuses, as: :abusable_item

  # Validations
  validates_length_of :message, in: 3..250, allow_nil: true
  validates_exclusion_of :message, in: Constants::Item::BLACKLISTED_WORDS,
    message: 'cannot contain blacklisted words'
end
