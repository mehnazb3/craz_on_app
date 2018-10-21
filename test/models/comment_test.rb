require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @comment_1_mb_1 = comments(:comment_1_mb_1)
    @comment_2_mb_1 = comments(:comment_2_mb_1)
    @comment_3_cmt_1 = comments(:comment_3_cmt_1)
    @comment_4_cmt_1 = comments(:comment_4_cmt_1)
    @comment_5_smb_1 = comments(:comment_5_smb_1)
  end

  # Validations
  #
  test 'valid comment' do
    assert @comment_1_mb_1.valid?
    assert @comment_3_cmt_1.valid?
  end

  test 'short message' do
    @comment_1_mb_1.message = ''
    @comment_1_mb_1.valid?
    assert_not_nil @comment_1_mb_1.errors[:message]
  end

  test 'long message' do
    @comment_1_mb_1.message = 'a' * 1501
    @comment_1_mb_1.valid?
    assert_not_nil @comment_1_mb_1.errors[:message]
  end

  test 'should not contain blacklisted words' do
    blacklisted_words.each do |blacklisted_word|
      @comment_1_mb_1.message += blacklisted_word
      @comment_1_mb_1.valid?
      assert_not_nil @comment_1_mb_1.errors[:message]
    end
  end

  test 'cannot reply to a comment more than one level' do
    new_comment = Comment.new(
      message: 'Reply comment to comment 1',
      location_id: 1,
      commentable_item_id: @comment_3_cmt_1.id,
      commentable_item_type: Comment.name,
      user_id: 1
    )
    new_comment.valid?
    assert_not_nil new_comment.errors[:is_a_reply]
  end

  # Associations
  #
  test 'belongs to location' do
    assert_not_nil @comment_2_mb_1.location
    assert_equal @comment_4_cmt_1.location.name, locations(:bangalore).name
  end

  test 'belongs to user' do
    assert_not_nil @comment_2_mb_1.user
    assert_equal @comment_4_cmt_1.user.id, users(:bharath).id
  end

  test 'belongs to commentable item' do
    assert_not_nil @comment_2_mb_1.commentable_item
    assert_equal @comment_4_cmt_1.commentable_item_id, @comment_1_mb_1.id
  end

  test 'has one comment' do
    assert_not_nil @comment_1_mb_1.comments
    assert @comment_1_mb_1.comments.pluck(:id).include?(@comment_3_cmt_1.id)
  end

  test 'can comment on a micro-blog, share or reply to a comment' do
    assert @comment_1_mb_1.commentable_item.is_a?(MicroBlog)
    assert @comment_5_smb_1.commentable_item.is_a?(Share)
    assert @comment_3_cmt_1.commentable_item.is_a?(Comment)
  end

  # Functionality
  #
  test 'when a comment is deleted, all of it`s likes and comments must get deleted but not the item on which the comment is made' do
    @comment_1_mb_1.destroy_record
    assert @comment_1_mb_1.is_status?(Constants::Item::Status::DELETED)
    @comment_1_mb_1.likes.each{ |like| assert like.is_status?(Constants::Item::Status::DELETED) }
    @comment_1_mb_1.comments.each do |comment|
      assert comment.is_status?(Constants::Item::Status::DELETED)
      comment.comments.each{ |comment| assert comment.is_status?(Constants::Item::Status::DELETED) }
    end
    assert_not @comment_1_mb_1.commentable_item.is_status?(Constants::Item::Status::DELETED)
  end

  test 'when a reply comment is deleted, all of it`s likes must get deleted but not the item on which the comment is made' do
    @comment_4_cmt_1.destroy_record
    assert @comment_4_cmt_1.is_status?(Constants::Item::Status::DELETED)
    @comment_4_cmt_1.likes.each{ |like| assert like.is_status?(Constants::Item::Status::DELETED) }
    assert_not @comment_4_cmt_1.commentable_item.is_status?(Constants::Item::Status::DELETED)
  end
end
