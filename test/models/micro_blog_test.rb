require 'test_helper'

class MicroBlogTest < ActiveSupport::TestCase
  def setup
    @anand_mb_1 = micro_blogs(:anand_mb_1)
  end

  # Validations
  #
  test 'valid' do
    assert @anand_mb_1
  end

  test 'short message' do
    @anand_mb_1.message = 'ab'
    @anand_mb_1.valid?
    assert_not_nil @anand_mb_1.errors[:message]
  end

  test 'long message' do
    @anand_mb_1.message = 'a' * 251
    @anand_mb_1.valid?
    assert_not_nil @anand_mb_1.errors[:message]
  end

  test 'should not contain blacklisted words' do
    blacklisted_words.each do |blacklisted_word|
      @anand_mb_1.message += blacklisted_word
      @anand_mb_1.valid?
      assert_not_nil @anand_mb_1.errors[:message]
    end
  end

  # Associations
  #
  test 'belongs to user' do
    assert_not_nil @anand_mb_1.user
    assert_equal @anand_mb_1.user.id, users(:anand).id
  end

  test 'belongs to location' do
    assert_not_nil @anand_mb_1.location
    assert_equal @anand_mb_1.location.name, locations(:chennai).name
  end

  # Functionality
  #
  test 'when a microblog is deleted, all of it`s likes, comments and shares must get deleted' do
    @anand_mb_1.destroy_record
    assert @anand_mb_1.is_status?(Constants::Item::Status::DELETED)
    @anand_mb_1.likes.each{ |like| assert like.is_status?(Constants::Item::Status::DELETED) }
    @anand_mb_1.comments.each do |comment|
      assert comment.is_status?(Constants::Item::Status::DELETED)
      comment.comments.each{ |comment| assert comment.is_status?(Constants::Item::Status::DELETED) }
    end
    @anand_mb_1.shares.each{ |share| assert share.is_status?(Constants::Item::Status::DELETED) }
  end
end
