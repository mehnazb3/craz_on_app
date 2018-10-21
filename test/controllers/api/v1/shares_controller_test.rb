require "test_helper"

class Api::V1::SharesControllerTest < ActionController::TestCase
  test 'before_action' do
    controller = Api::V1::SharesController.new
    filters = controller._process_action_callbacks.select { |c| c.kind == :before }.map(&:filter)
    assert_includes filters, :authenticate_user_token!
  end

  test 'create successfully' do
    share_message = 'Sample share message'
    micro_blog_id = 2
    process :create, method: :post,
      params: {
        share: {
          micro_blog_id: micro_blog_id,
          message: share_message
        }
      }
    assert_response :created
    assert_json_response(json_response, JsonResponseHelper::Shares::CREATE_OK)
    assert_equal Share.open_status.where(micro_blog_id: micro_blog_id, message: share_message).count, 1
  end

  test 'create with error' do
    share_message = 'An'
    micro_blog_id = 2
    process :create, method: :post,
      params: {
        share: {
          micro_blog_id: micro_blog_id,
          message: share_message
        }
      }
    assert_response :bad_request
    assert_json_response(json_response, JsonResponseHelper::Shares::CREATE_ERR)
    assert_equal Share.open_status.where(micro_blog_id: micro_blog_id, message: share_message).count, 0
  end

  test 'show' do
    process :show, method: :get, params: { id: 2 }
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::Shares::SHOW)
  end

  Share::ListBy::ITEMS.each do |item_name|
    test "list_by_share for #{item_name}" do
      process :list_by_share, method: :get, params: { id: 1, item: item_name }
      assert_response :ok
      assert_json_response(json_response, JsonResponseHelper::Shares::LIST_BY[item_name])
    end
  end

  test 'list_by_share with error' do
    process :list_by_share, method: :get, params: { id: 1, item: Share.name.underscore }
    assert_response :bad_request
    assert_json_response(json_response, JsonResponseHelper::Error::INVALID_PARAMETER)
  end

  test 'update successfully' do
    share_id = 2
    old_message = Share.open_status.where(id: share_id).pluck(:message).first
    process :update, method: :put,
      params: {
        id: share_id,
        share: { message: 'Updated share message' }
      }
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::Shares::UPDATE_OK)
    assert_not_equal Share.open_status.where(id: share_id).pluck(:message).first, old_message
  end

  test 'update with forbidden' do
    share_id = 1
    old_message = Share.open_status.where(id: share_id).pluck(:message).first
    process :update, method: :put,
      params: {
        id: share_id,
        share: { message: 'Updated share message' }
      }
    assert_response :forbidden
    assert_json_response(json_response, JsonResponseHelper::Error::ACCESS_FORBIDDEN)
    assert_equal Share.open_status.where(id: share_id).pluck(:message).first, old_message
  end

  test 'destroy successfully' do
    share_id = 1
    process :destroy, method: :delete, params: { id: share_id }
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::SUCCESS)
    assert Share.open_status.where(id: share_id).count, 0
  end

  test 'delete with forbidden' do
    share_id = 3
    process :destroy, method: :delete, params: { id: share_id }
    assert_response :forbidden
    assert_json_response(json_response, JsonResponseHelper::Error::ACCESS_FORBIDDEN)
    assert Share.open_status.where(id: share_id).count, 1
  end
end
