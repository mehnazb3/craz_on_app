module TestUnitExtensions
  def json_response
    @json_response_body ||= ActiveSupport::JSON.decode @response.body
  end

  def assert_exception_message(exception, message)
    assert_equal message, exception.message
  end
end

ActiveSupport::TestCase.send(:include, TestUnitExtensions)