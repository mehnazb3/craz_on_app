require 'test_helper'

class Api::V1::UserSessionsControllerTest < ActionController::TestCase
  def setup
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @request.env['HTTP_ACCEPT'] = 'application/json'
  end

  test 'create' do
    user = users(:anand)
    User.any_instance.expects(:generate_api_key).returns('some_api_key')
    process :create, method: :post,
      params: {
        user: {
          email: user.email,
          password: 'anands'
        }
      }
    assert_json_response(json_response, JsonResponseHelper::UserSessions::CREATE_OK)
    assert_response :created
  end

  test 'create with error' do
    process :create, method: :post,
      params: {
        user: {
          email: 'some.random@email.com',
          password: 'anands'
        }
      }
    assert_response :unauthorized
    assert_json_response(json_response, JsonResponseHelper::UserSessions::CREATE_ERR)
  end

  test 'destroy' do
    anand = users(:anand)
    @request.headers['x-api-key'] = 'some_api_key'
    User.expects(:from_api_key).with('some_api_key', true).returns(anand)
    User.expects(:cached_api_key).with('some_api_key').returns('api/some_api_key')
    ActiveSupport::Cache::FileStore.any_instance.expects(:delete).with('api/some_api_key')
    process :destroy, method: :delete
    assert_response :ok
    assert @response.body.blank?
  end

  test 'destroy a non-existing user`s session' do
    @request.headers['x-api-key'] = 'a_random_api_key'
    process :destroy, method: :delete
    assert_response :unauthorized
    assert_json_response(json_response, JsonResponseHelper::Error::NOT_AUTHENTICATED)
  end
end
