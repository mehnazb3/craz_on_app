class Api::V1::LikesController < ApplicationController
  load_and_authorize_resource only: :destroy

  swagger_controller :likes, "Like management"

  swagger_api :create do
    summary 'Like action'
    notes 'Likes a micro-blog/comment/share'
    param :form, :"like[:item_id]", :integer, :required, 'MicroBlog/Comment/Share ID'
    param_list :form, :"like[:item_type]", :string, :required, 'Item name to like', Like::ListBy::ITEMS
    response :created
    response :unauthorized
    response :bad_request
  end
  def create
    p "Indies"
    p params
    
    @micro_blog = @current_user.likes.new(like_params)
    if @micro_blog.save
      render :show, status: :created
    else
      render_error_state(@micro_blog.errors.full_messages.join(', '), :bad_request)
    end
  end

  swagger_api :destroy do
    summary 'Unlike action'
    notes 'Unlikes a micro-blog/comment/share'
    param :path, :id, :integer, :required, 'Like ID'
    response :ok
    response :unauthorized
    response :bad_request
  end
  def destroy
    @like.destroy
    render_success_json
  end

  private
  def like_params
    params.require(:like).permit(:item_id, :item_type)
  end
end
