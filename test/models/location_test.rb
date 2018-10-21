require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  def setup
    @chennai = locations(:chennai)
  end

  # Validations
  #
  test 'valid location' do
    assert @chennai.valid?
  end

  test 'no name' do
    @chennai.name = nil
    @chennai.valid?
    assert_not_nil @chennai.errors[:name]
  end

  # Associations
  #
  test 'has many users' do
    assert_not_nil @chennai.users
    assert @chennai.users.pluck(:id).include?(users(:anand).id)
  end

  test 'has many micro-blogs' do
    assert_not_nil @chennai.micro_blogs
    assert @chennai.micro_blogs.pluck(:id).include?(micro_blogs(:anand_mb_1).id)
  end

  test 'has many likes' do
    assert_not_nil @chennai.likes
    assert @chennai.likes.pluck(:id).include?(likes(:like_1).id)
  end

  test 'has many comments' do
    assert_not_nil @chennai.comments
    assert @chennai.comments.pluck(:id).include?(comments(:comment_1_mb_1).id)
  end

  test 'has many shares' do
    assert_not_nil @chennai.shares
    assert @chennai.shares.pluck(:id).include?(shares(:anand_smb_1).id)
  end

  test 'has many abuses' do
    assert_not_nil @chennai.abuses
    assert @chennai.abuses.pluck(:id).include?(abuses(:abuse_1).id)
  end
end
