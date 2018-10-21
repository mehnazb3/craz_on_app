class Api::V1::MicroBlogsController < ApplicationController
  load_and_authorize_resource only: [:show, :list_by_micro_blog, :update, :destroy]

  swagger_controller :micro_blogs, "MicroBlog management"

  swagger_api :create do
    summary 'Micro-blog create action'
    notes 'Creates a micro-blog'
    param :form, :"micro_blog[message]", :string, :required, 'Message of the micro-blog'
    response :created
    response :unauthorized
    response :bad_request
  end
  def create
    @micro_blog = @current_user.micro_blogs.new(micro_blog_params)
    if @micro_blog.save
      render :show, status: :created
    else
      render_error_state(@micro_blog.errors.full_messages.join(', '), :bad_request)
    end
  end

  swagger_api :show do
    summary 'Shows a micro-blog'
    notes 'Shows a micro-blog with message and possible actions'
    param :path, :id, :integer, :required, 'Micro-blog ID'
    response :ok
    response :unauthorized
    response :bad_request
  end
  def show
  end

  swagger_api :list_by_micro_blog do
    summary 'Show likes/comments/shares of micro-blog'
    notes 'Displays the information about the likes/comments/shares of a micro-blog'
    param :path, :id, :integer, :required, 'Micro-blog ID'
    param_list :query, :item, :string, :required, 'Item to retrieve', MicroBlog::ListBy::ITEMS
    response :ok
    response :unauthorized
    response :bad_request
  end
  def list_by_micro_blog
  end

  swagger_api :update do
    summary 'Micro-blog update action'
    notes 'Updates a micro-blog'
    param :path, :id, :integer, :required, 'Micro-blog ID'
    param :form, :"micro_blog[message]", :string, :required, 'Message of the micro-blog'
    response :ok
    response :unauthorized
    response :bad_request
  end
  def update
    if @micro_blog.update(micro_blog_params)
      render :show
    else
      render_error_state(@micro_blog.errors.full_messages.join(', '), :bad_request)
    end
  end

  swagger_api :destroy do
    summary 'Micro-blog destroy action'
    notes 'Deletes a micro-blog'
    param :path, :id, :integer, :required, 'Micro-blog ID'
    response :ok
    response :unauthorized
    response :bad_request
  end
  def destroy
    @micro_blog.destroy_record
    render_success_json
  end

  private

  def micro_blog_params
    params.require(:micro_blog).permit(:message)
  end
end
