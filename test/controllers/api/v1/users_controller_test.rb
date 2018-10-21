require 'test_helper'

class Api::V1::UsersControllerTest < ActionController::TestCase
  test 'before_action' do
    controller = Api::V1::UsersController.new
    filters = controller._process_action_callbacks.select { |c| c.kind == :before }.map(&:filter)
    assert_includes filters, :authenticate_user_token!
  end

  test 'show' do
    process :show, method: :get, params: { id: 1 }
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::Users::SHOW)
  end

  test 'show with forbidden' do
    process :show, method: :get, params: { id: 2 }
    assert_response :forbidden
    assert_json_response(json_response, JsonResponseHelper::Error::ACCESS_FORBIDDEN)
  end

  User::ListBy::ITEMS.each do |item_name|
    test "list_by_user for #{item_name}" do
      process :list_by_user, method: :get, params: { id: 1, item: item_name }
      assert_response :ok
      assert_json_response(json_response, JsonResponseHelper::Users::LIST_BY[item_name])
    end
  end

  test 'list_by_user with error' do
    process :list_by_user, method: :get, params: { id: 1, item: User.name.underscore }
    assert_response :bad_request
    assert_json_response(json_response, JsonResponseHelper::Error::INVALID_PARAMETER)
  end

  test 'update successfully' do
    user_id = 1
    old_f_name = User.where(id: user_id).pluck(:first_name).first
    process :update, method: :put,
      params: {
        id: user_id,
        user: { first_name: 'Updated_f_name' }
      }
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::Users::UPDATE_OK)
    assert_not_equal User.where(id: user_id).pluck(:first_name).first, old_f_name
  end

  test 'update with forbidden' do
    user_id = 2
    old_f_name = User.where(id: user_id).pluck(:first_name).first
    process :update, method: :put,
      params: {
        id: user_id,
        user: { first_name: 'Updated_f_name' }
      }
    assert_response :forbidden
    assert_json_response(json_response, JsonResponseHelper::Error::ACCESS_FORBIDDEN)
    assert_equal User.where(id: user_id).pluck(:first_name).first, old_f_name
  end

  test 'follow' do
    user_id = 4
    process :follow, method: :patch, params: { id: user_id }
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::SUCCESS)
    assert User.where(id: 1).first.follows?(user_id)
  end

  test 'follow with forbidden' do
    user_id = 2
    process :follow, method: :patch, params: { id: user_id }
    assert_response :forbidden
    assert_json_response(json_response, JsonResponseHelper::Error::ACCESS_FORBIDDEN)
    assert_not User.where(id: 1).first.follows?(user_id)
  end

  test 'unfollow' do
    user_id = 4
    users(:anand).follow(user_id)
    process :unfollow, method: :delete, params: { id: user_id }
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::SUCCESS)
    assert_not User.where(id: 1).first.follows?(user_id)
  end

  test 'unfollow with forbidden' do
    user_id = 2
    process :unfollow, method: :delete, params: { id: user_id }
    assert_response :forbidden
    assert_json_response(json_response, JsonResponseHelper::Error::ACCESS_FORBIDDEN)
    assert_not User.where(id: 1).first.follows?(user_id)
  end

  test 'block' do
    user_id = 4
    process :block, method: :patch, params: { id: user_id }
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::SUCCESS)
    assert User.where(id: 1).first.has_blocked?(user_id)
  end

  test 'block with forbidden' do
    user_id = 2
    assert User.where(id: 1).first.has_blocked?(user_id)
    process :block, method: :patch, params: { id: user_id }
    assert_response :forbidden
    assert_json_response(json_response, JsonResponseHelper::Error::ACCESS_FORBIDDEN)
  end

  test 'blocked_list' do
    process :blocked_list, method: :get
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::Users::BLOCKED_LIST)
    assert_equal json_response.count, User.where(id: 1).first.blockers.count
  end

  test 'unblock_users' do
    user_ids = [2, 3]
    users(:anand).block(3)
    process :unblock_users, method: :patch, params: { blocked_user_ids: user_ids.join(',') }
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::Users::UNBLOCK_USERS)
  end

  User::Timeline::ITEMS.each do |item_name|
    test "timeline for #{item_name}" do
      process :timeline, method: :get, params: { filter_by: item_name }
      assert_response :ok
      assert_json_response(json_response, JsonResponseHelper::Users::TIMELINE[item_name])
    end
  end

  test 'timeline with error' do
    process :timeline, method: :get, params: { filter_by: User.name.underscore }
    assert_response :bad_request
    assert_json_response(json_response, JsonResponseHelper::Error::INVALID_PARAMETER)
  end

  test 'update_password' do
    new_password = 'a_new_pswd'
    process :update_password, method: :post,
      params: {
        id: 1,
        user: {
          password: new_password,
          password_confirmation: new_password
        }
      }
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::SUCCESS)
    assert User.where(id: 1).first.valid_password?(new_password)
  end

  test 'update_password with forbidden' do
    new_password = 'a_new_pswd'
    process :update_password, method: :post,
      params: {
        id: 2,
        user: {
          password: new_password,
          password_confirmation: new_password
        }
      }
    assert_response :forbidden
    assert_json_response(json_response, JsonResponseHelper::Error::ACCESS_FORBIDDEN)
    assert_not User.where(id: 1).first.valid_password?(new_password)
  end
end
