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
    if params[:item_type].present?
      if Abuse::AbusableItem::LIST.include?(params[:item_type])
        @abuses = Abuse.filter_by_item_type(params[:item_type].classify.constantize.to_s).page(params[:page]).per(params[:per_page])
        render :index, status: :ok
      else
        render_error_state("Invalid parameter", :bad_request)
      end
    else
      @abuses = Abuse.unhandled.page(params[:page]).per(params[:per_page])
    end
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
    if params[:abuse][:abusable_item_type].present? && Abuse::AbusableItem::LIST.include?(params[:abuse][:abusable_item_type])
      object = params[:abuse][:abusable_item_type].classify.constantize.where(id: params[:abuse][:abusable_item_id]).first
      if object.present?
        @item = object.abuses.new(abuse_params)
        @item.user_id = current_user.id
        if @item.save
          render_success_json(:created)
        else
          render_error_state("Invalid parameter", :bad_request)
        end
      else
        render_error_state("Invalid parameter", :bad_request)
      end
    else
      render_error_state("Invalid parameter", :bad_request)
    end
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
    if params[:abuse_ids].present? && ['true', 'false', true, false].include?(params[:confirm_status])
      success = { results: [] }
      @abuses = Abuse.where(id: params[:abuse_ids].split(',').flatten.compact.uniq )
      @abuses.each do |abuse|
        abuse.has_been_handled = true
        abuse.is_confirmed = ActiveModel::Type::Boolean.new.cast(params[:confirm_status])
        if ActiveModel::Type::Boolean.new.cast(params[:confirm_status])
          abuse.abusable_item.abuse_record
        else
          abuse.abusable_item.update_column(:status, 0) if abuse.abusable_item.status == 1
        end
        success[:results] << { abuse_id: abuse.id } if abuse.save
      end
      render json: success, status: :ok
    else
      render_error_state("Invalid parameter", :bad_request)
    end
  end

  private
  def abuse_params
    params.require(:abuse).permit(:reason, :abusable_item_id, :abusable_item_type)
  end
end
