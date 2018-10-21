require "test_helper"

class Api::V1::MicroBlogsControllerTest < ActionController::TestCase
  test 'before_action' do
    controller = Api::V1::MicroBlogsController.new
    filters = controller._process_action_callbacks.select { |c| c.kind == :before }.map(&:filter)
    assert_includes filters, :authenticate_user_token!
  end

  test 'create successfully' do
    micro_blog_message = 'Sample micro-blog message'
    process :create, method: :post,
      params: {
        micro_blog: {
          message: micro_blog_message
        }
      }
    assert_equal MicroBlog.open_status.where(message: micro_blog_message).count, 1
    assert_response :created
    assert_json_response(json_response, JsonResponseHelper::MicroBlogs::CREATE_OK)
  end

  test 'create with error' do
    micro_blog_message = 'An'
    process :create, method: :post,
      params: {
        micro_blog: {
          message: micro_blog_message
        }
      }
    assert_equal MicroBlog.open_status.where(message: micro_blog_message).count, 0
    assert_response :bad_request
    assert_json_response(json_response, JsonResponseHelper::MicroBlogs::CREATE_ERR)
  end

  test 'show' do
    process :show, method: :get, params: { id: 2 }
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::MicroBlogs::SHOW)
  end

  MicroBlog::ListBy::ITEMS.each do |item_name|
    test "list_by_micro_blog for #{item_name}" do
      process :list_by_micro_blog, method: :get, params: { id: 1, item: item_name }
      assert_response :ok
      assert_json_response(json_response, JsonResponseHelper::MicroBlogs::LIST_BY[item_name])
    end
  end

  test 'list_by_micro_blog with error' do
    process :list_by_micro_blog, method: :get, params: { id: 1, item: MicroBlog.name.underscore }
    assert_response :bad_request
    assert_json_response(json_response, JsonResponseHelper::Error::INVALID_PARAMETER)
  end

  test 'update successfully' do
    micro_blog_id = 2
    old_message = MicroBlog.where(id: micro_blog_id).pluck(:message).first
    process :update, method: :put,
      params: {
        id: micro_blog_id,
        micro_blog: { message: 'Updated micro-blog message' }
      }
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::MicroBlogs::UPDATE_OK)
    assert_not_equal MicroBlog.where(id: micro_blog_id).pluck(:message).first, old_message
  end

  test 'update with forbidden' do
    micro_blog_id = 1
    old_message = MicroBlog.where(id: micro_blog_id).pluck(:message).first
    process :update, method: :put,
      params: {
        id: 1,
        micro_blog: { message: 'Updated micro-blog message' }
      }
    assert_equal MicroBlog.where(id: micro_blog_id).pluck(:message).first, old_message
    assert_response :forbidden
    assert_json_response(json_response, JsonResponseHelper::Error::ACCESS_FORBIDDEN)
  end

  test 'destroy successfully' do
    micro_blog_id = 1
    process :destroy, method: :delete, params: { id: micro_blog_id }
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::SUCCESS)
    assert_equal MicroBlog.open_status.where(id: micro_blog_id).count, 0
  end

  test 'delete with forbidden' do
    micro_blog_id = 3
    process :destroy, method: :delete, params: { id: micro_blog_id }
    assert_response :forbidden
    assert_json_response(json_response, JsonResponseHelper::Error::ACCESS_FORBIDDEN)
    assert_equal MicroBlog.open_status.where(id: micro_blog_id).count, 1
  end
end
