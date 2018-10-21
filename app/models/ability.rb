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
    end

    can [:index, :handle_abuses], Abuse do |abuse|
    end

    # Comments
    can :create, Comment do |comment|
    end

    can :show, Comment do |comment|
    end

    can :destroy, Comment do |comment|
    end

    can :update, Comment do |comment|
    end

    # Likes
    can :create, Like do |like|
    end

    can :destroy, Like do |like|
    end

    # MicroBlogs
    can :destroy, MicroBlog do |micro_blog|
    end

    can :show, MicroBlog do |micro_blog|
    end

    can :list_by_micro_blog, MicroBlog do |micro_blog|
    end

    can :update, MicroBlog do |micro_blog|
    end

    # Shares
    can :create, Share do |share|
    end

    can :destroy, Share do |share|
    end

    can :show, Share do |share|
    end

    can :list_by_share, Share do |share|
    end

    can :update, Share do |share|
    end

    # Users
    can [:show, :list_by_user, :unfollow], User do |user_instance|
    end

    can :follow, User do |user_instance|
      p "user_instance"
      p user_instance
      p "user"
      p user
      !user.follows?(user_instance)
    end

    can :unfollow, User do |user_instance|
      user.follows?(user_instance)
    end

    can :block, User do |user_instance|
    end

    can [:update, :blocked_list, :unblock_users, :update_password], User do |user_instance|
    end
  end
end
