class Api::V1::CommentsController < ApplicationController
  load_and_authorize_resource only: [:update, :destroy]

  swagger_controller :comments, "Comment management"

  swagger_api :create do
    summary 'Creates a comment'
    notes 'Comment on MicroBlog/Comment/Share'
    param :form, :"comment[message]", :string, :required, 'Comment content'
    param :form, :"comment[item_id]", :integer, :required, 'MicroBlog/Comment/Share ID'
    param_list :form, :"comment[item_type]", :string, :required, 'Item name to comment', Comment::ListBy::ITEMS
    response :created
    response :unauthorized
    response :bad_request
  end
  def create
    if params[:comment][:message].present? && params[:comment][:item_type].present? && Comment::ListBy::ITEMS.include?(params[:comment][:item_type])
      object = params[:comment][:item_type].classify.constantize.where(id: params[:comment][:item_id]).first

      if object.present?
        @item = object.comments.new({message: params[:comment][:message]})
        if object.is_a?(Comment)
          @item.is_a_reply = true
        end
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

  swagger_api :update do
    summary 'Updates a comment'
    notes 'Update comment message'
    param :path, :id, :string, :required, 'Comment ID'
    param :form, :"comment[message]", :string, :required, 'Comment content'
    response :ok
    response :unauthorized
    response :bad_request
  end
  def update
    if @comment.update(message: params[:comment][:message])
      render_success_json
    else
      render_error_state(@comment.errors.full_messages.join(', '), :bad_request)
    end
  end

  swagger_api :destroy do
    summary 'Delete action'
    notes 'Deletes a comment'
    param :path, :id, :integer, :required, 'Comment ID'
    response :ok
    response :unauthorized
    response :bad_request
  end
  def destroy
    @comment.destroy_record
    render_success_json
  end

  private
  def comment_params
    params.require(:comment).permit(:message, :item_id, :item_type)
  end
end
