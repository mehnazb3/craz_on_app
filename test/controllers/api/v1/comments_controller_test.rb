require "test_helper"

class Api::V1::CommentsControllerTest < ActionController::TestCase
  test 'before_action' do
    controller = Api::V1::CommentsController.new
    filters = controller._process_action_callbacks.select { |c| c.kind == :before }.map(&:filter)
    assert_includes filters, :authenticate_user_token!
  end

  test 'create successfully' do
    comment_message = 'Sample comment'
    process :create, method: :post,
      params: {
        comment: {
          message: comment_message,
          item_id: 1,
          item_type: MicroBlog.name.underscore
        }
      }
    assert_response :created
    assert_json_response(json_response, JsonResponseHelper::SUCCESS)
    assert_equal Comment.where(message: comment_message).count, 1
  end

  test 'create with error' do
    comment_message = 'Sample comment'
    process :create, method: :post,
      params: {
        comment: {
          message: comment_message,
          item_id: 1,
          item_type: User.name.underscore
        }
      }
    assert_response :bad_request
    assert_json_response(json_response, JsonResponseHelper::Error::INVALID_PARAMETER)
    assert_equal Comment.where(message: comment_message).count, 0
  end

  test 'update successfully' do
    comment_id = 3
    old_message = Comment.where(id: comment_id).pluck(:message).first
    process :update, method: :put,
      params: {
        id: comment_id,
        comment: { message: 'Updated comment message' }
      }
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::SUCCESS)
    assert_not_equal Comment.where(id: comment_id).pluck(:message).first, old_message
  end

  test 'update with forbidden' do
    comment_id = 1
    old_message = Comment.where(id: comment_id).pluck(:message).first
    process :update, method: :put,
      params: {
        id: comment_id,
        comment: { message: 'Updated comment message' }
      }
    assert_response :forbidden
    assert_json_response(json_response, JsonResponseHelper::Error::ACCESS_FORBIDDEN)
    assert_equal Comment.where(id: comment_id).pluck(:message).first, old_message
  end

  test 'destroy successfully' do
    comment_id = 3
    process :destroy, method: :delete, params: { id: comment_id }
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::SUCCESS)
    assert_equal Comment.where(id: comment_id).open_status.count, 0
    assert_equal Comment.where(id: comment_id, status: Constants::Item::Status::DELETED).count, 1
  end

  test 'destroy with forbidden' do
    process :destroy, method: :delete, params: { id: 2 }
    assert_response :forbidden
    assert_json_response(json_response, JsonResponseHelper::Error::ACCESS_FORBIDDEN)
    assert_equal Comment.where(id: 3).open_status.count, 1
  end
end
