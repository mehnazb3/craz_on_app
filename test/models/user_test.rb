require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @anand = users(:anand)
  end

  # Validations
  #
  test 'valid user' do
    assert @anand.valid?
  end

  test 'no email' do
    @anand.email = nil
    @anand.valid?
    assert_not_nil @anand.errors[:email]
  end

  test 'invalid email format' do
    @anand.email = 'invalid.email'
    @anand.valid?
    assert_not_nil @anand.errors[:email]
  end

  test 'duplicate email' do
    new_user = User.new(
      email: 'anand.s@rails_e2_soln.com',
      first_name: 'Aravindan',
      last_name: 'Sai',
      location_id: 1
    )
    new_user.valid?
    assert_not_nil new_user.errors[:email]
  end

  test 'short first name' do
    @anand.first_name = 'A'
    @anand.valid?
    assert_not_nil @anand.errors[:first_name]
  end

  test 'long first name' do
    @anand.first_name = 'A' * 16
    @anand.valid?
    assert_not_nil @anand.errors[:first_name]
  end

  test 'short last name' do
    @anand.last_name = 'S'
    @anand.valid?
    assert_not_nil @anand.errors[:last_name]
  end

  test 'long last name' do
    @anand.last_name = 'S' * 16
    @anand.valid?
    assert_not_nil @anand.errors[:last_name]
  end

  test 'short password' do
    new_user = User.new(
      email: 'anand.s@rails_e2_soln.com',
      first_name: 'Aravindan',
      last_name: 'Sai',
      location_id: 1
    )
    new_user.password = 'short'
    new_user.valid?
    assert_not_nil new_user.errors[:password]
  end

  test 'long password' do
    new_user = User.new(
      email: 'anand.s@rails_e2_soln.com',
      first_name: 'Aravindan',
      last_name: 'Sai',
      location_id: 1
    )
    new_user.password = 'p' * 16
    new_user.valid?
    assert_not_nil new_user.errors[:password]
  end

  test 'invalid gender' do
    @anand.gender = 'Do not care'
    @anand.valid?
    assert_not_nil @anand.errors[:gender]
  end

  test 'invalid location' do
    @anand.location_id = 100
    @anand.valid?
    assert_not_nil @anand.errors[:location_id]
  end

  # Associations
  #
  test 'belongs to a location' do
    assert_not_nil @anand.location
    assert_equal @anand.location.name, locations(:chennai).name
  end
end
