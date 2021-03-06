class User < ApplicationRecord
  extend BackendJobs
  
  include Gravtastic
  gravtastic

  module Timeline
    ITEMS = [MicroBlog, Share].map(&:name).map(&:underscore)
  end

  module ListBy
    ITEMS = [MicroBlog, Like, Comment, Share].map(&:name).map(&:underscore)
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable
  
  has_many :micro_blogs
  has_many :shares
  has_many :comments
  has_many :abuses
  has_many :likes
  belongs_to :location

  has_many :follower_relationships, foreign_key: :followed_id, class_name: 'Follow'
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :following_relationships, foreign_key: :follower_id, class_name: 'Follow'
  has_many :followed_by, through: :following_relationships, source: :followed
  
  has_many :blocker_relationships, foreign_key: :blocked_id, class_name: 'Block'
  has_many :blockers, through: :blocker_relationships, source: :blocker

  has_many :blocked_relationships, foreign_key: :blocker_id, class_name: 'Block'
  has_many :blocked_by, through: :blocked_relationships, source: :blocked
  

  # Associations

  # Validations
  validates :email, presence: true, uniqueness: true, format: /\w+@\w+\.{1}[a-zA-Z]{2,}/
  validates :first_name, presence: true, length: {minimum: 3, maximum: 15}
  validates :last_name,  presence: true, length: {minimum: 3, maximum: 15}
  validates :password,  presence: true, length: {minimum: 8, maximum: 15}, on: :create

  # Callback
  before_save :ensure_auth_token, if: lambda { |entry| entry[:auth_token].blank? }

  # Callback method
  def ensure_auth_token
    self.auth_token = formulate_key
  end
  
  def generate_api_key
    api_key = formulate_key
    # Write it into cache
    Rails.cache.write(User.cached_api_key(api_key), self.auth_token, expires_in: 520)
    # Return the hash
    api_key
  end

  # Class methods
  class << self
    def from_api_key(api_key, renew = false)
      cached_key = self.cached_api_key(api_key)
      auth_token = Rails.cache.read cached_key
      if auth_token
        user = User.find_by_auth_token auth_token
        # Renew the token
        if renew && user.present?
          Rails.cache.write cached_key, auth_token, expires_in: 520
        end
      end
      user
    end

    def cached_api_key(api_key)
      "api/#{api_key}"
    end
  end

  # Instance methods

  def fetch_timeline_items(filter_by, current_user_id)
  end

  def convert_to_hashes(contents, current_user_id)
  end

  def owns?(item_id, item_type)
    item_type.constantize.exists?(id: item_id, user_id: id)
  end

  def follows?(user_id)
    self.followers.pluck(:id).include?(user_id)
  end

  def is_followed_by?(user_id)
    self.followed_by.pluck(:id).include?(user_id)
  end

  def has_blocked?(user_id)
    p 'has_blocked'
    p self
    p "self.blockers"
    p self.blockers
    p "user_id"
    p user_id
    self.blockers.pluck(:id).include?(user_id)
  end

  def has_been_blocked_by?(user_id)
    self.blocked_by.pluck(:id).include?(user_id)
  end

  def follow(follower_id)
    self.followers << User.where(id: follower_id).first
  end

  def unfollow(follower_id)
    follower = User.where(id: follower_id).first
    self.followers.delete(follower)
  end

  def block(blocker_id)
    blocker = User.where(id: blocker_id).first
    self.blockers << blocker
  end

  def unblock(blocker_id)
    self.blockers.delete(User.where(id: blocker_id).first)
  end

  private
  def formulate_key
    str = OpenSSL::Digest::SHA256.digest("#{SecureRandom.uuid}_#{self.email}_#{Time.now.to_i}")
    Base64.encode64(str).gsub(/[\s=]+/, "").tr('+/','-_')
  end

  

end
