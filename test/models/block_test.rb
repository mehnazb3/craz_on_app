require "test_helper"

class BlockTest < ActiveSupport::TestCase
  def setup
    @block_u1_u2 = blocks(:block_u1_u2)
  end

  # Validations
  #
  test 'valid' do
    assert @block_u1_u2.valid?
  end

  test 'no blocker id' do
    @block_u1_u2.blocker_id = nil
    @block_u1_u2.valid?
    assert_not_nil @block_u1_u2.errors[:blocker_id]
  end

  test 'no blocked id' do
    @block_u1_u2.blocked_id = nil
    @block_u1_u2.valid?
    assert_not_nil @block_u1_u2.errors[:blocked_id]
  end

  test 'non-numeric blocker id' do
    @block_u1_u2.blocker_id = 'wrong'
    @block_u1_u2.valid?
    assert_not_nil @block_u1_u2.errors[:blocker_id]
  end

  test 'non-numeric blocked id' do
    @block_u1_u2.blocked_id = 'wrong'
    @block_u1_u2.valid?
    assert_not_nil @block_u1_u2.errors[:blocked_id]
  end

  # Associations
  #
  test 'blocker' do
    assert_not_nil @block_u1_u2.blocker
    assert_equal @block_u1_u2.blocker.id, users(:anand).id
  end

  test 'blocked' do
    assert_not_nil @block_u1_u2.blocked
    assert_equal @block_u1_u2.blocked.id, users(:bharath).id
  end

  # Functionality
  #
  test 'can block user' do
    users(:chandru).block(users(:durga).id)
    assert users(:chandru).has_blocked?(users(:durga).id)
    assert users(:durga).has_been_blocked_by?(users(:chandru).id)
  end

  test 'can unblock user' do
    users(:chandru).block(users(:durga).id)
    assert users(:chandru).has_blocked?(users(:durga).id)
    assert users(:durga).has_been_blocked_by?(users(:chandru).id)
    users(:chandru).unblock(users(:durga).id)
    assert_not users(:chandru).has_blocked?(users(:durga).id)
    assert_not users(:durga).has_been_blocked_by?(users(:chandru).id)
  end

  test 'blocking a user removes from following' do
    users(:chandru).follow(users(:durga).id)
    assert users(:chandru).follows?(users(:durga).id)
    assert users(:durga).is_followed_by?(users(:chandru).id)
    users(:chandru).block(users(:durga).id)
    assert_not users(:chandru).follows?(users(:durga).id)
    assert_not users(:durga).is_followed_by?(users(:chandru).id)
  end

  test 'unblocking a user does not add to following' do
    users(:chandru).follow(users(:durga).id)
    assert users(:chandru).follows?(users(:durga).id)
    assert users(:durga).is_followed_by?(users(:chandru).id)
    users(:chandru).block(users(:durga).id)
    assert_not users(:chandru).follows?(users(:durga).id)
    assert_not users(:durga).is_followed_by?(users(:chandru).id)
    users(:chandru).unblock(users(:durga).id)
    assert_not users(:chandru).follows?(users(:durga).id)
    assert_not users(:durga).is_followed_by?(users(:chandru).id)
  end
end
