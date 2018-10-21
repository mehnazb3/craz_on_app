class Api::V1::LocationsController < ApplicationController
  swagger_controller :locations, "Location based actions"

  swagger_api :index do
    summary 'Location list'
    notes 'List of all locations in the system'
    response :ok
    response :unauthorized
  end
  def index
    @locations = Location.all
  end

  swagger_api :list_by_location do
    summary 'Show items of location'
    notes 'Displays the information about an item of a location'
    param :path, :id, :integer, :required, 'Location ID'
    param_list :query, :item, :string, :required, 'Item to retrieve', Location::ListBy::ITEMS
    response :ok
    response :unauthorized
    response :bad_request
  end
  def list_by_location
    @item_name = params[:item]
    if Location::ListBy::ITEMS.include?(@item_name.underscore) && Location.exists?(id: params[:id])
      @item_name = @item_name.camelize unless @item_name.is_a?(Array)
      @items = @item_name.constantize.where(location_id: params[:id])
      @items = @items.viewable_users(@current_user.blocked_by.pluck(:id)).open_status unless @item_name == User.name
    else
      render_error_state('Invalid parameter', :bad_request)
    end
  end

  swagger_api :show do
    summary 'Location show page'
    notes 'Displays the information about a location'
    param :path, :id, :integer, :required, 'Location ID'
    response :ok
    response :unauthorized
    response :bad_request
  end
  def show
    @location = Location.where(id: params[:id]).first
    if @location.nil?
      render_error_state('Invalid parameter', :bad_request)
    end
  end
end
