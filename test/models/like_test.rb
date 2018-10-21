require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup
    @like_1 = likes(:like_1)
    @like_2 = likes(:like_2)
    @like_3 = likes(:like_3)
    @like_4 = likes(:like_4)
    @like_5 = likes(:like_5)
  end

  # Associations
  #
  test 'belongs to user' do
    assert_not_nil @like_1.user
    assert_equal @like_2.user.id, users(:bharath).id
  end

  test 'belongs to location' do
    assert_not_nil @like_3.location
    assert_equal @like_4.location.name, locations(:bangalore).name
  end

  test 'belongs to likable item' do
    assert_not_nil @like_5.likable_item
    assert_equal @like_5.likable_item.id, comments(:comment_4_cmt_1).id
  end

  test 'can like a microblog, share, comment or a reply comment' do
    assert @like_1.likable_item.is_a?(MicroBlog)
    assert @like_3.likable_item.is_a?(Share)
    assert @like_4.likable_item.is_a?(Comment)
    assert @like_5.likable_item.is_a?(Comment) && @like_5.likable_item.is_a_reply
  end
end
