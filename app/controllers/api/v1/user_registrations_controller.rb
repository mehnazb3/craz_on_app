class Api::V1::UserRegistrationsController < Devise::RegistrationsController
  skip_before_action :authenticate_user_token!

  swagger_controller :user_registrations, "User registration management"

  swagger_api :create do
    summary ''
    notes ''
    param :form, :"user[email]", :string, :required, 'User email ID'
    param :form, :"user[password]", :password, :required, 'Password for the account'
    param :form, :"user[password_confirmation]", :password, :required, 'Password confirmation'
    param :form, :"user[first_name]", :string, :required, 'First name of user'
    param :form, :"user[last_name]", :string, :required, 'Last name of user'
    param_list :form, :"user[gender]", :string, :required, 'Gender of user', Constants::User::Gender::ALL
    param :form, :"user[location_id]", :integer, :required, 'Location ID of user from the list of all locations'
    response :created
    response :bad_request
  end
  def create
    user = User.new(registration_params)
    if user.save
      UserMailer.welcome_user(user).deliver_later
      sign_in(User.name, user)
      render json: { api_key: user.generate_api_key }, status: :created
    else
      render_error_state(user.errors.full_messages.join(', '), :bad_request)
    end
  end

  private
  def registration_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :gender, :location_id)
  end
end
