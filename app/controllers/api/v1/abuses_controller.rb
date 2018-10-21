class Api::V1::AbusesController < ApplicationController
  load_and_authorize_resource only: [:index, :handle_abuses]

  swagger_controller :comments, "Comment management"

  swagger_api :index do
    summary 'Lists all abuses'
    notes 'Lists out all abuses on MicroBlog/Comment/Share'
    param :query, :page, :integer, :optional, 'Page number'
    param :query, :per_page, :integer, :optional, 'Per page'
    param_list :query, :item_type, :string, :optional, 'Filter the abuses list based on the abusable items', Abuse::AbusableItem::LIST
    response :ok
    response :unauthorized
    response :bad_request
  end
  def index
  end

  swagger_api :create do
    summary 'Create abuse'
    notes 'Creates an abuses on MicroBlog/Comment/Share'
    param :form, :"abuse[reason]", :integer, :optional, 'Reason for abuse'
    param :form, :"abuse[abusable_item_id]", :integer, :optional, 'Abusable item ID'
    param_list :form, :"abuse[abusable_item_type]", :string, :optional, 'Abusable item type', Abuse::AbusableItem::LIST
    response :created
    response :unauthorized
    response :bad_request
  end
  def create
  end

  swagger_api :handle_abuses do
    summary 'Handle abuses'
    notes 'Handles the abuse on a set of items'
    param :query, :abuse_ids, :string, :required, 'Set of abuse IDs separated by comma'
    param :query, :confirm_status, :integer, :required, 'Boolean value as string for abuse confirm or not. True for confirm.'
    response :ok
    response :unauthorized
    response :bad_request
  end
  def handle_abuses
  end

  private
  def abuse_params
    params.require(:abuse).permit(:reason, :abusable_item_id, :abusable_item_type)
  end
end
