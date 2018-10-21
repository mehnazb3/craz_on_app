class Api::V1::SharesController < ApplicationController
  load_and_authorize_resource only: [:show, :list_by_share, :update, :destroy]

  swagger_controller :shares, "Share management"

  swagger_api :create do
    summary 'Shares a micro-blog'
    notes 'Creates a share of a micro-blog'
    param :form, :"share[micro_blog_id]", :integer, :required, 'MicroBlog ID'
    param :form, :"share[message]", :string, :optional, 'Share content by user'
    response :created
    response :unauthorized
    response :bad_request
  end
  def create
    @share = @current_user.shares.new(share_params)
    if @share.save
      render :show, status: :created
    else
      render_error_state(@share.errors.full_messages.join(', '), :bad_request)
    end
  end

  swagger_api :show do
    summary 'Shows a share'
    notes 'Shows a share with message and possible actions'
    param :path, :id, :integer, :required, 'Share ID'
    response :ok
    response :unauthorized
    response :bad_request
  end
  def show
  end

  swagger_api :list_by_share do
    summary 'Show likes/comments of share'
    notes 'Displays the information about the likes/comments of a share'
    param :path, :id, :integer, :required, 'Share ID'
    param_list :query, :item, :string, :required, 'Item to retrieve', Share::ListBy::ITEMS
    response :ok
    response :unauthorized
    response :bad_request
  end
  def list_by_share
    if params[:id].present? && Share::ListBy::ITEMS.include?(params[:item])
      object = Share.where(id: params[:id]).first
      if object.present?
        @item_name = params[:item]
        if @item_name == 'like'
          @items = object.likes
        elsif @item_name == 'comment'
          @items = object.comments
        end
      else
        render_error_state("Invalid parameter", :bad_request)
      end
    else
      render_error_state("Invalid parameter", :bad_request)
    end
  end

  swagger_api :update do
    summary 'Updates share'
    notes 'Update share message'
    param :path, :id, :string, :required, 'Share ID'
    param :form, :"share[message]", :string, :optional, 'Share content'
    response :ok
    response :unauthorized
    response :bad_request
  end
  def update
    if @share.update(message: params[:share][:message])
      render :show
    else
      render_error_state(@share.errors.full_messages.join(', '), :bad_request)
    end
  end

  swagger_api :destroy do
    summary 'Delete action'
    notes 'Deletes a share'
    param :path, :id, :integer, :required, 'Share ID'
    response :ok
    response :unauthorized
    response :bad_request
  end
  def destroy
    @share.destroy_record
    render_success_json
  end

  private
  def share_params
    params.require(:share).permit(:message, :micro_blog_id)
  end
end
