class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    # Abuses
    can :create, Abuse do |abuse|
      abuse.abusable_item.status == 0
    end

    can [:index, :handle_abuses], Abuse do |abuse|
      user.is_admin
    end

    # Comments
    can :create, Comment do |comment|
      comment.commentable_item.status == 0
    end

    can :show, Comment do |comment|
      comment.status == 0
    end

    can :destroy, Comment do |comment|
      comment.user_id == user.id && comment.abuses.confirmed.blank?
    end

    can :update, Comment do |comment|
      comment.user_id == user.id && comment.likes.blank? && comment.comments.blank? && comment.abuses.confirmed.blank?
    end

    # Likes
    can :create, Like do |like|
      like.likable_item.present? ? like.likable_item.status == 0 : (like.status == 0 && user.present?)
    end

    can :destroy, Like do |like|
      like.user_id == user.id && like.status == 0
    end

    # MicroBlogs
    can :destroy, MicroBlog do |micro_blog|
      micro_blog.user_id == user.id && micro_blog.abuses.confirmed.blank? && micro_blog.status == 0
    end

    can :show, MicroBlog do |micro_blog|
      !micro_blog.user.has_blocked?(user.id) && !user.has_blocked?(micro_blog.user_id) && micro_blog.status == 0
    end

    can :list_by_micro_blog, MicroBlog do |micro_blog|
      micro_blog.status == 0 && micro_blog.user_id == user.id
    end

    can :update, MicroBlog do |micro_blog|
      micro_blog.user_id == user.id && micro_blog.likes.blank? && micro_blog.comments.blank? && micro_blog.shares.blank? && micro_blog.abuses.confirmed.blank?
    end

    # Shares
    can :create, Share do |share|
      share.micro_blog.status == 0
    end

    can :destroy, Share do |share|
      share.user_id == user.id && share.abuses.confirmed.blank? && share.status == 0
    end

    can :show, Share do |share|
      !share.user.has_blocked?(user.id) && !user.has_blocked?(share.user_id) && share.status == 0
    end

    can :list_by_share, Share do |share|
      share.status != 0 || share.user_id == user.id || user.is_admin
    end

    can :update, Share do |share|
      share.user_id == user.id && share.likes.blank? && share.comments.blank? && share.abuses.confirmed.blank?
    end

    # Users
    can [:show, :list_by_user], User do |user_instance|
      !user_instance.has_blocked?(user.id) && !user.has_blocked?(user_instance.id)
    end

    can :follow, User do |user_instance|
      !user.follows?(user_instance.id) && user_instance.id != user.id && !user.has_blocked?(user_instance.id) && !user_instance.has_blocked?(user.id)
    end

    can :unfollow, User do |user_instance|
      user.id != user_instance.id && !user_instance.has_blocked?(user.id) && !user.has_blocked?(user_instance.id)
    end

    can :block, User do |user_instance|
      user_instance.id != user.id && user.blockers.pluck(:id).exclude?(user_instance.id) && !user_instance.is_admin
    end

    can [:update, :update_password], User do |user_instance|
      user.id == user_instance.id
    end

    can [ :blocked_list, :unblock_users], User do |user_instance|
      user_instance.present? && user.id == user_instance.id
    end
  end
end
