require 'test_helper'

class BackendJobsTest < ActiveSupport::TestCase
  def setup
    @user_durga = users(:durga)
    @initial_points = @user_durga.points
    @initial_titles = @user_durga.title
  end

  test "add #{CRAZ_ON_SETTINGS[:points][:likes_100]} points for 100 likes and #{CRAZ_ON_SETTINGS[:points][:blogs_100]} points for 100 micro-blogs" do
    100.times.each do
      @user_durga.micro_blogs.create(message: 'Testing points').likes.create(user_id: @user_durga.id)
    end
    User.calculate_points
    @user_durga.reload
    like_points = CRAZ_ON_SETTINGS[:points][:likes_100]
    micro_blog_points = CRAZ_ON_SETTINGS[:points][:blogs_100]
    assert_equal (@initial_points + like_points + micro_blog_points), @user_durga.points
  end

  test "do not add #{CRAZ_ON_SETTINGS[:points][:likes_100]} points for 100 likes and #{CRAZ_ON_SETTINGS[:points][:blogs_100]} points for 100 micro-blogs" do
    10.times.each do
      @user_durga.micro_blogs.create(message: 'Testing points').likes.create(user_id: @user_durga.id)
    end
    User.calculate_points
    @user_durga.reload
    assert_equal @initial_points, @user_durga.points
  end

  test "add #{CRAZ_ON_SETTINGS[:points][:comments_100]} points for 100 comments and #{CRAZ_ON_SETTINGS[:points][:shares_100]} points for 100 shares" do
    100.times.each do
      micro_blogs(:bharath_mb_4).shares.create(user_id: @user_durga.id).comments.create(message: 'a', user_id: @user_durga.id)
    end
    User.calculate_points
    @user_durga.reload
    comment_points = CRAZ_ON_SETTINGS[:points][:comments_100]
    share_points = CRAZ_ON_SETTINGS[:points][:shares_100]
    assert_equal (@initial_points + comment_points + share_points), @user_durga.points
  end

  test "do not add #{CRAZ_ON_SETTINGS[:points][:comments_100]} points for 100 comments and #{CRAZ_ON_SETTINGS[:points][:shares_100]} points for 100 shares" do
    10.times.each do
      micro_blogs(:bharath_mb_4).shares.create(user_id: @user_durga.id).comments.create(message: 'a', user_id: @user_durga.id)
    end
    User.calculate_points
    @user_durga.reload
    assert_equal @initial_points, @user_durga.points
  end

  test "get #{CRAZ_ON_SETTINGS[:titles][:likes_100]}, #{CRAZ_ON_SETTINGS[:titles][:comments_100]}, #{CRAZ_ON_SETTINGS[:titles][:blogs_100]}, #{CRAZ_ON_SETTINGS[:titles][:shares_100]}, #{CRAZ_ON_SETTINGS[:titles][:all_1000]} titles" do
    200.times.each do |i|
      User.create(
        email: "test#{i}@rails_e2_soln.com",
        password: 'testUser',
        password_confirmation: 'testUser',
        first_name: 'RailsE2',
        last_name: "Test#{i}",
        gender: Constants::User::Gender::MALE,
        location_id: 1).follow(@user_durga.id)
      @user_durga.micro_blogs.create(message: 'Testing titles').likes.create(user_id: @user_durga.id)
      micro_blogs(:bharath_mb_4).shares.create(user_id: @user_durga.id).comments.create(message: 'a', user_id: @user_durga.id)
    end
    User.award_titles
    @user_durga.reload
    assert_equal @initial_titles.length, 0
    assert_includes @user_durga.title.split(', '), CRAZ_ON_SETTINGS[:titles][:likes_100]
    assert_includes @user_durga.title.split(', '), CRAZ_ON_SETTINGS[:titles][:comments_100]
    assert_includes @user_durga.title.split(', '), CRAZ_ON_SETTINGS[:titles][:blogs_100]
    assert_includes @user_durga.title.split(', '), CRAZ_ON_SETTINGS[:titles][:shares_100]
    assert_includes @user_durga.title.split(', '), CRAZ_ON_SETTINGS[:titles][:all_1000]
  end

  test "do not get #{CRAZ_ON_SETTINGS[:titles][:likes_100]}, #{CRAZ_ON_SETTINGS[:titles][:comments_100]}, #{CRAZ_ON_SETTINGS[:titles][:blogs_100]}, #{CRAZ_ON_SETTINGS[:titles][:shares_100]}, #{CRAZ_ON_SETTINGS[:titles][:all_1000]} titles" do
    20.times.each do |i|
      User.create(
        email: "test#{i}@rails_e2_soln.com",
        password: 'testUser',
        password_confirmation: 'testUser',
        first_name: 'RailsE2',
        last_name: "Test#{i}",
        gender: Constants::User::Gender::MALE,
        location_id: 1).follow(@user_durga.id)
      @user_durga.micro_blogs.create(message: 'Testing titles').likes.create(user_id: @user_durga.id)
      micro_blogs(:bharath_mb_4).shares.create(user_id: @user_durga.id).comments.create(message: 'a', user_id: @user_durga.id)
    end
    User.award_titles
    @user_durga.reload
    assert_equal @initial_titles.length, 0
    assert_equal @user_durga.title.length, 0
  end

  test "get #{CRAZ_ON_SETTINGS[:titles][:abused_blocked_100]} title" do
    100.times.each do |i|
      User.create(
        email: "test#{i}@rails_e2_soln.com",
        password: 'testUser',
        password_confirmation: 'testUser',
        first_name: 'RailsE2',
        last_name: "Test#{i}",
        gender: Constants::User::Gender::MALE,
        location_id: 1).block(@user_durga.id)
      @user_durga.micro_blogs.create(message: 'Testing title').abuses.create(reason: 'Testing title', user_id: @user_durga.id).update_abuse_confirmation(true)
    end
    User.award_titles
    @user_durga.reload
    assert_equal @initial_titles.length, 0
    assert_equal @user_durga.title, CRAZ_ON_SETTINGS[:titles][:abused_blocked_100]
  end

  test "do not get #{CRAZ_ON_SETTINGS[:titles][:abused_blocked_100]} title" do
    10.times.each do |i|
      User.create(
        email: "test#{i}@rails_e2_soln.com",
        password: 'testUser',
        password_confirmation: 'testUser',
        first_name: 'RailsE2',
        last_name: "Test#{i}",
        gender: Constants::User::Gender::MALE,
        location_id: 1).block(@user_durga.id)
      @user_durga.micro_blogs.create(message: 'Testing title').abuses.create(reason: 'Testing title', user_id: @user_durga.id).update_abuse_confirmation(true)
    end
    User.award_titles
    @user_durga.reload
    assert_equal @initial_titles.length, 0
    assert_equal @user_durga.title.length, 0
  end

  test "get #{CRAZ_ON_SETTINGS[:titles][:blocks_100]} title" do
    100.times.each do |i|
      @user_durga.block(User.create(
        email: "test#{i}@rails_e2_soln.com",
        password: 'testUser',
        password_confirmation: 'testUser',
        first_name: 'RailsE2',
        last_name: "Test#{i}",
        gender: Constants::User::Gender::MALE,
        location_id: 1).id)
    end
    User.award_titles
    @user_durga.reload
    assert_equal @initial_titles.length, 0
    assert_equal @user_durga.title, CRAZ_ON_SETTINGS[:titles][:blocks_100]
  end

  test "do not get #{CRAZ_ON_SETTINGS[:titles][:blocks_100]} title" do
    10.times.each do |i|
      @user_durga.block(User.create(
        email: "test#{i}@rails_e2_soln.com",
        password: 'testUser',
        password_confirmation: 'testUser',
        first_name: 'RailsE2',
        last_name: "Test#{i}",
        gender: Constants::User::Gender::MALE,
        location_id: 1).id)
    end
    User.award_titles
    @user_durga.reload
    assert_equal @initial_titles.length, 0
    assert_equal @user_durga.title.length, 0
  end
end