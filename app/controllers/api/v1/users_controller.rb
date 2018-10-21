class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_user_token!, only: :create
  load_and_authorize_resource except: [ :create, :timeline ]

  swagger_controller :users, "User management"

  swagger_api :show do
    summary 'User show page'
    notes 'Displays the information about a user'
    param :path, :id, :integer, :required, 'User ID'
    response :ok
    response :unauthorized
    response :bad_request
  end
  def show
  end

  swagger_api :list_by_user do
    summary 'Show items of user'
    notes 'Displays the information about an item of a user'
    param :path, :id, :integer, :required, 'User ID'
    param_list :query, :item, :string, :required, 'Item to retrieve', User::ListBy::ITEMS
    response :ok
    response :unauthorized
    response :bad_request
  end
  def list_by_user
  end

  swagger_api :update do
    summary 'User update action'
    notes 'Updates the details of a user'
    param :path, :"id", :integer, :required, 'ID of user'
    param :form, :"user[first_name]", :string, :required, 'First name of user'
    param :form, :"user[last_name]", :string, :required, 'Last name of user'
    param_list :form, :"user[gender]", :string, :required, 'Gender of user', Constants::User::Gender::ALL
    param :form, :"user[location_id]", :integer, :required, 'Location ID where the user is'
    response :ok
    response :unauthorized
    response :bad_request
  end
  def update
    if @user.update(user_params)
      render :show
    else
      render_error_state(@user.errors.full_messages.join(', '), :bad_request)
    end
  end

  swagger_api :follow do
    summary 'Follow user'
    notes 'Follows a given user'
    param :path, :id, :integer, :required, 'User ID'
    response :ok
    response :unauthorized
    response :bad_request
  end
  
  def follow
    @current_user.follow(params[:id])
    render_success_json
  end

  swagger_api :unfollow do
    summary 'Unfollow user'
    notes 'Unfollows a given user'
    param :path, :id, :integer, :required, 'User ID'
    response :ok
    response :unauthorized
    response :bad_request
  end
  def unfollow
    @current_user.unfollow(params[:id])
    render_success_json
  end

  swagger_api :block do
    summary 'Block user'
    notes 'Blocks a given user'
    param :path, :id, :integer, :required, 'User ID'
    response :ok
    response :unauthorized
    response :bad_request
  end
  def block
    @current_user.block(params[:id])
    render_success_json
  end

  swagger_api :blocked_list do
    summary 'Blocked users list'
    notes 'List of all blocked users by current logged in user'
    response :ok
    response :unauthorized
    response :bad_request
  end
  def blocked_list
    @blocked_users = @current_user.blockers
  end

  swagger_api :unblock_users do
    summary 'Unblock users'
    notes 'Unblocks a set of users who were blocked by current logged in user'
    param :query, :blocked_user_ids, :string, :required, 'Set of blocked user IDs separated by comma'
    response :ok
    response :unauthorized
    response :bad_request
  end
  def unblock_users
  end

  swagger_api :timeline do
    summary 'User timeline'
    notes 'Timeline for a user with all micro-blog/share posted by self and users followed'
    param :query, :page, :integer, :optional, 'Page number'
    param :query, :per_page, :integer, :optional, 'Per page'
    param_list :query, :filter_by, :integer, :optional, 'Item names to filter contents', User::Timeline::ITEMS
    response :ok
    response :unauthorized
    response :bad_request
  end
  def timeline
  end

  swagger_api :update_password do
    summary 'User update password action'
    notes 'Updates the password details of a user'
    param :path, :id, :integer, :required, 'User ID'
    param :form, :"user[password]", :password, :required, 'New password of user'
    param :form, :"user[password_confirmation]", :password, :required, 'Confirmation of user`s new password'
    response :ok
    response :unauthorized
    response :bad_request
  end
  def update_password
    if @user.update(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
      render_success_json
    else
      render_error_state(@user.errors.full_messages.join(', '), :bad_request)
    end
  end

  private
  def create_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :gender, :location_id)
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :gender, :location_id)
  end
end
