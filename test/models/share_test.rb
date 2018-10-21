require 'test_helper'

class ShareTest < ActiveSupport::TestCase
  def setup
    @anand_smb_1 = shares(:anand_smb_1)
  end

  # Validations
  #
  test 'valid share' do
    assert @anand_smb_1.valid?
  end

  test 'short message' do
    @anand_smb_1.message = 'ab'
    @anand_smb_1.valid?
    assert_not_nil @anand_smb_1.errors[:message]
  end

  test 'long message' do
    @anand_smb_1.message = 'a' * 251
    @anand_smb_1.valid?
    assert_not_nil @anand_smb_1.errors[:message]
  end

  test 'optional message' do
    @anand_smb_1.message = nil
    assert @anand_smb_1.valid?
  end

  test 'should not contain blacklisted words' do
    blacklisted_words.each do |blacklisted_word|
      @anand_smb_1.message += blacklisted_word
      @anand_smb_1.valid?
      assert_not_nil @anand_smb_1.errors[:message]
    end
  end

  # Associations
  #
  test 'belongs to location' do
    assert_not_nil @anand_smb_1.location
    assert_equal @anand_smb_1.location.id, locations(:chennai).id
  end

  test 'belongs to user' do
    assert_not_nil @anand_smb_1.user
    assert_equal @anand_smb_1.user.id, users(:anand).id
  end

  test 'belongs to micro-blog' do
    assert_not_nil @anand_smb_1.micro_blog
    assert_equal @anand_smb_1.micro_blog.id, micro_blogs(:anand_mb_1).id
  end

  # Functionality
  #
  test 'when a share is deleted, all of it`s likes and comments must get deleted but not the micro-blog which has been shared' do
    @anand_smb_1.destroy_record
    assert @anand_smb_1.is_status?(Constants::Item::Status::DELETED)
    @anand_smb_1.likes.each{ |like| assert like.is_status?(Constants::Item::Status::DELETED) }
    @anand_smb_1.comments.each do |comment|
      assert comment.is_status?(Constants::Item::Status::DELETED)
      comment.comments.each{ |comment| assert comment.is_status?(Constants::Item::Status::DELETED) }
    end
    assert_not @anand_smb_1.micro_blog.is_status?(Constants::Item::Status::DELETED)
  end
end
