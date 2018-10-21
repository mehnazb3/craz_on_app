class Api::V1::LikesController < ApplicationController
  load_and_authorize_resource only: [:create, :destroy]

  swagger_controller :likes, "Like management"

  swagger_api :create do
    summary 'Like action'
    notes 'Likes a micro-blog/comment/share'
    param :form, :"like[item_id]", :integer, :required, 'MicroBlog/Comment/Share ID'
    param_list :form, :"like[item_type]", :string, :required, 'Item name to like', Like::ListBy::ITEMS
    response :created
    response :unauthorized
    response :bad_request
  end

  def create
    if params[:like][:item_type].present? && Like::ListBy::ITEMS.include?(params[:like][:item_type])
      object = params[:like][:item_type].classify.constantize.where(id: params[:like][:item_id]).first
      if object.present?
        @item = object.likes.new(likable_item_id: params[:like][:item_id], likable_item_type: params[:like][:item_type].classify.constantize.to_s )
        @item.user_id = current_user.id
        if @item.save
          #render :show_list, status: :created
          render_success_json(:created)
        else
          render_error_state(@item.errors.full_messages.join(', '), :bad_request)
        end
      else
        render_error_state("Invalid parameter", :bad_request)
      end
    else
      render_error_state("Invalid parameter", :bad_request)
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
    params.require(:like).permit(:likable_item_id, :likable_item_type)
  end
end
