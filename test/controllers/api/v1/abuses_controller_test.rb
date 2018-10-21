require 'test_helper'

class Api::V1::AbusesControllerTest < ActionController::TestCase
  test 'before_action' do
    controller = Api::V1::AbusesController.new
    filters = controller._process_action_callbacks.select { |c| c.kind == :before }.map(&:filter)
    assert_includes filters, :authenticate_user_token!
  end

  test 'index' do
    process :index, method: :get
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::Abuses::INDEX)
  end

  test 'index with error' do
    process :index, method: :get, params: { item_type: Abuse.name.underscore }
    assert_response :bad_request
    assert_json_response(json_response, JsonResponseHelper::Error::INVALID_PARAMETER)
  end

  test 'create successfully' do
    abuse_reason = 'Reason to Abuse'
    process :create, method: :post,
      params: {
        abuse: {
          reason: abuse_reason,
          abusable_item_type: MicroBlog.name.underscore,
          abusable_item_id: 1
        }
      }
    assert_response :created
    assert_json_response(json_response, JsonResponseHelper::SUCCESS)
    assert_equal Abuse.where(reason: abuse_reason).count, 1
  end

  test 'create with error' do
    abuse_reason = 'Reason to Abuse'
    process :create, method: :post,
      params: {
        abuse: {
          reason: abuse_reason,
          abusable_item_type: Abuse.name.underscore,
          abusable_item_id: 1
        }
      }
    assert_response :bad_request
    assert_json_response(json_response, JsonResponseHelper::Error::INVALID_PARAMETER)
    assert_equal Abuse.where(reason: abuse_reason).count, 0
  end

  test 'handle_abuses' do
    @abuse_ids = [1, 2 ,3]
    process :handle_abuses, method: :get,
      params: {
        abuse_ids: @abuse_ids.join(','),
        confirm_status: true.to_s
      }
    abuse_counts = json_response['results'].map{ |result| result['abuse_id'] }.count
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::Abuses::HANDLE_ABUSES)
    assert Abuse.where(id: @abuse_ids).pluck(:has_been_handled).uniq.first
    assert_equal abuse_counts, @abuse_ids.count
  end

  test 'handle_abuses with error' do
    @abuse_ids = [1, 2 ,3]
    process :handle_abuses, method: :get,
      params: {
        abuse_ids: @abuse_ids.join(','),
        confirm_status: 'sample'
      }
    assert_not Abuse.where(id: @abuse_ids).pluck(:has_been_handled).uniq.first
    assert_response :bad_request
    assert_json_response(json_response, JsonResponseHelper::Error::INVALID_PARAMETER)
  end
end