require "test_helper"

class FollowTest < ActiveSupport::TestCase
  def setup
    @follow_u1_u3 = follows(:follow_u1_u3)
  end

  # Validations
  #
  test 'valid' do
    assert @follow_u1_u3.valid?
  end

  test 'no follower id' do
    @follow_u1_u3.follower_id = nil
    @follow_u1_u3.valid?
    assert_not_nil @follow_u1_u3.errors[:follower_id]
  end

  test 'no followed id' do
    @follow_u1_u3.followed_id = nil
    @follow_u1_u3.valid?
    assert_not_nil @follow_u1_u3.errors[:followed_id]
  end

  test 'non-numeric follower id' do
    @follow_u1_u3.follower_id = 'wrong'
    @follow_u1_u3.valid?
    assert_not_nil @follow_u1_u3.errors[:follower_id]
  end

  test 'non-numeric followed id' do
    @follow_u1_u3.followed_id = 'wrong'
    @follow_u1_u3.valid?
    assert_not_nil @follow_u1_u3.errors[:followed_id]
  end

  # Associations
  #
  test 'follower' do
    assert_not_nil @follow_u1_u3.follower
    assert_equal @follow_u1_u3.follower.id, users(:anand).id
  end

  test 'followed' do
    assert_not_nil @follow_u1_u3.followed
    assert_equal @follow_u1_u3.followed.id, users(:chandru).id
  end

  # Functionality
  #
  test 'can follow user' do
    users(:chandru).follow(users(:durga).id)
    assert users(:chandru).follows?(users(:durga).id)
    assert users(:durga).is_followed_by?(users(:chandru).id)
  end

  test 'can unfollow user' do
    users(:chandru).follow(users(:durga).id)
    assert users(:chandru).follows?(users(:durga).id)
    assert users(:durga).is_followed_by?(users(:chandru).id)
    users(:chandru).unfollow(users(:durga).id)
    assert_not users(:chandru).follows?(users(:durga).id)
    assert_not users(:durga).is_followed_by?(users(:chandru).id)
  end
end
