# frozen_string_literal: true

class Api::V1::UserSessionsController < Devise::SessionsController
  skip_before_action :authenticate_user_token!, only: :create
  skip_before_action :verify_signed_out_user

  swagger_controller :user_sessions, "User login management"

  swagger_api :create do
    summary 'User authentication'
    notes 'Authenticate a user to the application and returns back authentication token'
    param :form, :'user[email]', :string, :required, 'Email'
    param :form, :'user[password]', :password, :required, 'Password'
    response :created
    response :unauthorized
  end
  def create
    resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    # Clearing out the session cookie on API auths
    respond_to do |format|
      format.json {
        session.clear
        render json: { api_key: resource.generate_api_key }, status: :created
      }
    end
  end

  swagger_api :destroy do
    summary 'Signout a user'
    notes 'Removes the authentication token of an user'
    response :ok
    response :unauthorized
    response :bad_request
  end
  def destroy
    sign_out(current_user) if current_user
    if request.env["HTTP_X_API_KEY"].present?
      Rails.cache.delete User.cached_api_key(request.env["HTTP_X_API_KEY"])
    end
    respond_to do |format|
      format.json {
        head :ok
      }
    end
  end
end
