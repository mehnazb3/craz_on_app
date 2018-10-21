require 'test_helper'

class Api::V1::UserRegistrationsControllerTest < ActionController::TestCase
  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  def call_create(email)
    process :create, method: :post,
      params: {
        user: {
          email: email,
          password: 'samP@sw0d',
          password_confirmation: 'samP@sw0d',
          first_name: 'Sample',
          last_name: 'User',
          gender: Constants::User::Gender::MALE,
          location_id: Location.select(:id).first.id
        }
      }
  end

  test 'create successfully' do
    new_email = 'sample_user@rails_e2_soln.com'
    call_create(new_email)
    assert_equal User.where(email: new_email).count, 1
    assert_response :created
    assert_json_response(json_response, JsonResponseHelper::UserRegistrations::CREATE_OK)
  end

  test 'create with error' do
    new_email = 'sample_user rails_e2_soln.com'
    call_create(new_email)
    assert_equal User.where(email: new_email).count, 0
    assert_response :bad_request
    assert_json_response(json_response, JsonResponseHelper::UserRegistrations::CREATE_ERR)
  end
end
