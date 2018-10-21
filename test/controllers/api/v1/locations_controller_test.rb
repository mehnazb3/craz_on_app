require 'test_helper'

class Api::V1::LocationsControllerTest < ActionController::TestCase
  test 'before_action' do
    controller = Api::V1::AbusesController.new
    filters = controller._process_action_callbacks.select { |c| c.kind == :before }.map(&:filter)
    assert_includes filters, :authenticate_user_token!
  end

  test 'index' do
    process :index, method: :get
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::Locations::INDEX)
    assert_equal json_response.count, Location.all.count
  end

  test 'show' do
    location_id = 2
    process :show, method: :get, params: { id: location_id }
    assert_response :ok
    assert_json_response(json_response, JsonResponseHelper::Locations::SHOW)
  end

  test 'show with error' do
    process :show, method: :get, params: { id: 9 }
    assert_response :bad_request
    assert_json_response(json_response, JsonResponseHelper::Error::INVALID_PARAMETER)
  end

  Location::ListBy::ITEMS.each do |item_name|
    test "list_by_location for #{item_name}" do
      process :list_by_location, method: :get, params: { id: 1, item: item_name}
      assert_response :ok
      assert_json_response(json_response, JsonResponseHelper::Locations::LIST_BY[item_name])
    end
  end

  test 'list_by_location with error' do
    process :list_by_location, method: :get, params: { id: 1, item: Location.name.underscore }
    assert_response :bad_request
    assert_json_response(json_response, JsonResponseHelper::Error::INVALID_PARAMETER)
  end
end
