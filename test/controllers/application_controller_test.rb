require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase

  def setup
    @anand = users(:anand)
  end

  # Callbacks
  test 'before_action is set' do
    controller = ApplicationController.new
    filters = controller._process_action_callbacks.select { |c| c.kind == :before }.map(&:filter)
    assert_includes filters, :authenticate_user_token!
  end
end
