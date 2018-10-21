require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  def setup
    @user_ability = Ability.new(users(:bharath))
  end

  # Abuse abilities
  #
  test 'for action create on Abuse' do
    assert @user_ability.can?(:create, micro_blogs(:bharath_mb_4).abuses.new)
    assert @user_ability.cannot?(:create, micro_blogs(:chandru_mb_5).abuses.new)
    assert @user_ability.cannot?(:create, micro_blogs(:chandru_mb_6).abuses.new)
  end

  [:index, :handle_abuses].each do |abuse_action|
    test "for action #{abuse_action} on Abuse" do
      assert Ability.new(users(:anand)).can?(abuse_action, abuses(:abuse_1))
      assert @user_ability.cannot?(abuse_action, abuses(:abuse_2))
    end
  end

  # Comment abilities
  #
  test 'for action create on Comment' do
      assert @user_ability.can?(:create, micro_blogs(:bharath_mb_4).comments.new)
      assert @user_ability.cannot?(:create, micro_blogs(:chandru_mb_5).comments.new)
      assert @user_ability.cannot?(:create, micro_blogs(:chandru_mb_6).comments.new)
  end

  test 'for action update on Comment' do
    assert @user_ability.can?(:update, comments(:comment_5_smb_1))
    assert @user_ability.cannot?(:update, comments(:comment_3_cmt_1))
  end

  test 'for action destroy on Comment' do
    assert @user_ability.can?(:destroy, comments(:comment_4_cmt_1))
    assert @user_ability.cannot?(:destroy, comments(:comment_3_cmt_1))
  end

  # Like ability
  #
  test 'for action create on Like' do
      assert @user_ability.can?(:create, micro_blogs(:bharath_mb_4).likes.new)
      assert @user_ability.cannot?(:create, micro_blogs(:chandru_mb_5).likes.new)
      assert @user_ability.cannot?(:create, micro_blogs(:chandru_mb_6).likes.new)
  end

  test 'for action destroy on Like' do
    assert @user_ability.can?(:destroy, likes(:like_2))
    assert @user_ability.cannot?(:destroy, likes(:like_1))
  end

  # MicroBlog abilities
  #
  [:destroy, :show, :list_by_micro_blog, :update].each do |micro_blog_action|
    test "for action #{micro_blog_action} on MicroBlog" do
      assert @user_ability.can?(micro_blog_action, micro_blogs(:bharath_mb_4))
      assert @user_ability.cannot?(micro_blog_action, micro_blogs(:anand_mb_2))
    end
  end

  # Share abilities
  #
  test 'for action create on Share' do
      assert @user_ability.can?(:create, micro_blogs(:bharath_mb_4).shares.new)
      assert @user_ability.cannot?(:create, micro_blogs(:chandru_mb_5).shares.new)
      assert @user_ability.cannot?(:create, micro_blogs(:chandru_mb_6).shares.new)
  end

  [:destroy, :show, :list_by_share, :update].each do |share_action|
    test "for action #{share_action} on Share" do
      assert @user_ability.can?(share_action, shares(:bharath_smb_3))
      assert @user_ability.cannot?(share_action, shares(:anand_smb_2))
    end
  end

  # User abilities
  #
  [:show, :list_by_user, :follow, :unfollow, :block].each do |user_action|
    test "for action #{user_action} on User" do
      assert @user_ability.can?(user_action, users(:chandru))
      assert @user_ability.cannot?(user_action, users(:anand))
      if [:follow, :unfollow, :block].include?(user_action)
        assert @user_ability.cannot?(user_action, users(:anand))
      end
    end
  end

  [:update, :blocked_list, :unblock_users, :update_password].each do |user_action|
    test "for action #{user_action} on User" do
      assert @user_ability.can?(user_action, users(:bharath))
      assert @user_ability.cannot?(user_action, users(:chandru))
    end
  end
end
