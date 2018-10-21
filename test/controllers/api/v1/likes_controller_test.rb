require "test_helper"

class Api::V1::LikesControllerTest < ActionController::TestCase
  test 'before_action' do
    controller = Api::V1::LikesController.new
    filters = controller._process_action_callbacks.select { |c| c.kind == :before }.map(&:filter)
    assert_includes filters, :authenticate_user_token!
  end

  test 'create successfully' do
    likable_item = { id: 2, type: Comment.name }
    old_like_count = Like.where(
      likable_item_id: likable_item[:id],
      likable_item_type: likable_item[:type]
    ).count
    process :create, method: :post,
      params: {
        like: {
          item_id: likable_item[:id],
          item_type: likable_item[:type].underscore
        }
      }
    new_like_count = Like.where(
      likable_item_id: likable_item[:id],
      likable_item_type: likable_item[:type]
    ).count
    assert_equal old_like_count + 1, new_like_count
    assert_response :created
    assert_json_response(json_response, JsonResponseHelper::SUCCESS)
  end

  test 'create with error' do
    likable_item = { id: 2, type: User.name }
    old_like_count = Like.where(
      likable_item_id: likable_item[:id],
      likable_item_type: likable_item[:type]
    ).count
    process :create, method: :post,
      params: {
        like: {
          item_id: likable_item[:id],
          item_type: likable_item[:type].underscore
        }
      }
    new_like_count = Like.where(
      likable_item_id: likable_item[:id],
      likable_item_type: likable_item[:type]
    ).count
    assert_equal old_like_count, new_like_count
    assert_response :bad_request
    assert_json_response(json_response, JsonResponseHelper::Error::INVALID_PARAMETER)
  end

  test 'destroy successfully' do
    like_id = 1
    process :destroy, method: :post, params: { id: like_id }
    assert_equal Like.where(id: like_id).count, 0
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::SUCCESS)
  end

  test 'destroy with forbidden' do
    like_id = 2
    process :destroy, method: :post, params: { id: like_id }
    assert_equal Like.where(id: like_id).count, 1
    assert_response :forbidden
    assert_json_response(json_response, JsonResponseHelper::Error::ACCESS_FORBIDDEN)
  end
end
