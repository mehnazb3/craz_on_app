require 'test_helper'

class AbuseTest < ActiveSupport::TestCase
  def setup
    @abuse_1 = abuses(:abuse_1)
    @abuse_2 = abuses(:abuse_2)
    @abuse_3 = abuses(:abuse_3)
    @abuse_4 = abuses(:abuse_4)
    @abuse_5 = abuses(:abuse_5)
  end

  # Validations
  #
  test 'valid abuse' do
    assert @abuse_1.valid?
  end

  test 'short reason' do
    @abuse_1.reason = 'short'
    @abuse_1.valid?
    assert_not_nil @abuse_1.errors[:reason]
  end

  test 'long reason' do
    @abuse_1.reason = 'a' * 1251
    @abuse_1.valid?
    assert_not_nil @abuse_1.errors[:reason]
  end

  test 'should not contain blacklisted words' do
    blacklisted_words.each do |blacklisted_word|
      @abuse_1.reason += blacklisted_word
      @abuse_1.valid?
      assert_not_nil @abuse_1.errors[:reason]
    end
  end

  test 'should confirm or not when handled' do
    @abuse_1.has_been_handled = true
    @abuse_1.valid?
    assert_not_nil @abuse_1.errors[:is_confirmed]
  end

  # Associations
  #
  test 'belongs to user' do
    assert_not_nil @abuse_1.user
    assert_equal @abuse_2.user.id, users(:bharath).id
  end

  test 'belongs to location' do
    assert_not_nil @abuse_3.location
    assert_equal @abuse_4.location.name, locations(:bangalore).name
  end

  test 'belongs to abusable item' do
    assert_not_nil @abuse_5.abusable_item
    assert_equal @abuse_5.abusable_item.id, comments(:comment_4_cmt_1).id
  end

  test 'can abuse a micro-blog, share, comment and a reply comment' do
    assert @abuse_1.abusable_item.is_a?(MicroBlog)
    assert @abuse_2.abusable_item.is_a?(Share)
    assert @abuse_3.abusable_item.is_a?(Comment)
    assert @abuse_5.abusable_item.is_a?(Comment) && @abuse_5.abusable_item.is_a_reply
  end

  # Functionality
  #
  def assert_abuse_on_item(item)
    assert item.is_status?(Constants::Item::Status::ABUSED)
  end

  def assert_abuse_on_parent_item(parent_item)
    assert_not parent_item.is_status?(Constants::Item::Status::ABUSED)
  end

  test 'when a micro-blog is reported, all of it`s likes, comments and shares must get abused' do
    @abuse_1.update_abuse_confirmation true
    assert_abuse_on_item @abuse_1.abusable_item
    @abuse_1.abusable_item.likes.each{ |like| assert_abuse_on_item like }
    @abuse_1.abusable_item.comments.each do |comment|
      assert_abuse_on_item comment
      comment.comments.each{ |comment| assert_abuse_on_item comment }
    end
    @abuse_1.abusable_item.shares.each{ |share| assert_abuse_on_item share }
  end

  test 'when a share is reported, all of it`s likes and comments must get abused but not the micro-blog' do
    @abuse_2.update_abuse_confirmation true
    assert_abuse_on_item @abuse_2.abusable_item
    @abuse_2.abusable_item.likes.each{ |like| assert_abuse_on_item like }
    @abuse_2.abusable_item.comments.each do |comment|
      assert_abuse_on_item comment
      comment.comments.each{ |comment| assert_abuse_on_item comment }
    end
    assert_abuse_on_parent_item @abuse_2.abusable_item.micro_blog
  end

  test 'when a comment is reported, all of it`s likes and reply comments must get abused but not the item on which the comment is made' do
    @abuse_3.update_abuse_confirmation true
    assert_abuse_on_item @abuse_3.abusable_item
    @abuse_3.abusable_item.likes.each{ |like| assert_abuse_on_item like }
    @abuse_3.abusable_item.comments.each do |comment|
      assert_abuse_on_item comment
      comment.comments.each{ |comment| assert_abuse_on_item comment }
    end
    assert_abuse_on_parent_item @abuse_3.abusable_item.commentable_item
  end

  test 'when a reply comment is reported, all of it`s likes must get abused but not the item on which the reply comment is made' do
    @abuse_5.update_abuse_confirmation true
    assert_abuse_on_item @abuse_5.abusable_item
    @abuse_5.abusable_item.likes.each{ |like| assert_abuse_on_item like }
    assert_abuse_on_parent_item @abuse_5.abusable_item.commentable_item
  end
end
