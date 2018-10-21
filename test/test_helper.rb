ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'rails-controller-testing'
Minitest::Reporters.use!(Minitest::Reporters::JUnitReporter.new, ENV, Minitest.backtrace_filter)
require 'json_response_helper'

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
# require "minitest/pride"

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures [ :locations, :users, :follows, :blocks, :micro_blogs, :shares, :likes, :comments, :abuses ]
  # Add more helper methods to be used by all tests here...

  def setup
    if @request.present?
      @request.env['HTTP_ACCEPT'] = 'application/json'
      @request.headers['x-api-key'] = 'some_api_key'
    end
    ActiveSupport::Cache::FileStore.any_instance.stubs(:read).returns("anandsai_auth")
  end

  def blacklisted_words
    Constants::Item::BLACKLISTED_WORDS
  end

  def assert_json_response(actual_response, expected_response)
    if expected_response.is_a?(Array)
      assert actual_response.is_a?(Array) && (actual_response.length == expected_response.length)
    else
      expected_response.keys.each do |key|
        assert actual_response.has_key?(key)
        if expected_response[key].is_a?(Hash)
          assert_json_response(actual_response[key], expected_response[key])
        elsif expected_response[key].is_a?(Array)
          assert actual_response[key].is_a?(Array) && (actual_response[key].length == expected_response[key].length)
        elsif expected_response[key].present?
          assert_equal actual_response[key], expected_response[key]
        elsif actual_response[key].present?
          assert actual_response[key]
        end
      end
    end
  end
end

require 'mocha/setup'
require 'test_unit_extensions'
require 'custom_headers'