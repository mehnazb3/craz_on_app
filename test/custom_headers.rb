module CustomHeaders
  def before_setup
    super
    @request.headers['X-API-KEY'] = 'some_api_key'
  end

  ActionController::TestCase.send(:include, self)
end
