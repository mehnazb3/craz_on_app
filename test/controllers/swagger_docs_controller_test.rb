require 'test_helper'

class SwaggerDocsControllerTest < ActionDispatch::IntegrationTest
  test 'index' do
    get '/'
    assert_response :ok
  end
end
