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
    if params[:id].present?
      @user = User.where(id: params[:id]).first
    else
      render_error_state("Invalid parameter", :bad_request)
    end
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
    if params[:item].present? && params[:id].present? && User::ListBy::ITEMS.include?(params[:item])
      @items = params[:item].classify.constantize.where(user_id: params[:id] )
      @item_name = params[:item]
    else
      render_error_state("Invalid parameter", :bad_request)
    end
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
    if params[:id].present?
      @current_user.follow(params[:id])
      render_success_json
    else
      render_error_state("Invalid parameter", :bad_request)
    end
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
    if params[:id].present?
      @current_user.unfollow(params[:id])
      render_success_json
    else
      render_error_state("Invalid parameter", :bad_request)
    end
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
    if params[:id].present?
      @current_user.block(params[:id])
      render_success_json
    else
      render_error_state("Invalid parameter", :bad_request)
    end
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
    result = []
    if @blocked_users.present?
      @blocked_users.each do |blocked_user|
        result << { id: blocked_user.id, email: blocked_user.email, first_name: blocked_user.first_name, last_name:blocked_user.last_name, location_id:blocked_user.location_id, location_name: blocked_user.location.name }
      end
    end
    render json: result, status: :ok
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
    if params[:blocked_user_ids].present?
      result = {results: []}
      user_ids = params[:blocked_user_ids].split(",").flatten.compact.uniq
      user_ids.each do |user_id|
        status = @current_user.unblock(user_id)
        result[:results] << {user_id: user_id, result: status }
      end
      render json: result, status: :ok
    else
      render_error_state("Invalid parameter", :bad_request)
    end
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
    user_ids = @current_user.followers.map(&:id) + [@current_user.id] - [@current_user.blockers.pluck(:id)]
    if params[:filter_by].present?
      if User::Timeline::ITEMS.include?(params[:filter_by])
        object_type = params[:filter_by].classify.constantize.to_s
        if object_type == MicroBlog.to_s
          @items = MicroBlog.where(status: 0, user_id: user_ids).page(params[:page]).per(params[:per_page])
        elsif object_type == Share.to_s
          @items = Share.where(status: 0, user_id: user_ids).page(params[:page]).per(params[:per_page])
        else
          render_error_state("Invalid parameter", :bad_request)
        end
        result = {timeline: []}
        @items.each do |item|
          hash = {id: item.id, message: item.message, created_at: item.created_at , updated_at: item.updated_at, like_id: nil, user: item.user, likes: item.likes, comments: item.comments}
          if item.class.to_s != Share.to_s
            hash[:shares_count] = item.shares.count
          end
          result[:timeline] << hash
        end
        render json: result, status: :ok
      else
        render_error_state("Invalid parameter", :bad_request)
      end
    else
      @items = Kaminari.paginate_array(MicroBlog.where(status: 0, user_id: user_ids) + Share.where(status: 0, user_id: user_ids) ).page(params[:page]).per(params[:per_page])
    end
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
