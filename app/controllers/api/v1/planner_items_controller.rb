class Api::V1::PlannerItemsController < ApplicationController
  before_action :authorize_request
  before_action :set_planner_item, only: [:destroy]

  # GET /api/v1/planner_items
  def index
  if params[:date].present?
    date = Date.parse(params[:date]) rescue nil
    if date
      planner_items = @current_user.planner_items.where(planned_date: date).order(:meal_type)
    else
      return render json: { errors: ['Invalid date format'] }, status: :bad_request
    end
  else
    planner_items = @current_user.planner_items.order(:planned_date)
  end

  render json: planner_items, status: :ok
end


  # POST /api/v1/planner_items
  def create
    planner_item = @current_user.planner_items.new(planner_item_params)

    if planner_item.save
      render json: planner_item, status: :created
    else
      render json: { errors: planner_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

#   UPDATE /api/v1/planner_items/:id
  def update
  planner_item = @current_user.planner_items.find_by(id: params[:id])

  if planner_item.nil?
    return render json: { errors: ['Planner item not found'] }, status: :not_found
  end

  if planner_item.update(planner_item_params)
    render json: planner_item, status: :ok
  else
    render json: { errors: planner_item.errors.full_messages }, status: :unprocessable_entity
  end
end


  # DELETE /api/v1/planner_items/:id
  def destroy
    @planner_item.destroy
    render json: { message: 'Meal removed from planner' }, status: :ok
  end

  private

  def planner_item_params
    params.require(:planner_item).permit(:spoonacular_id, :title, :image, :meal_type, :planned_date)
  end

  def set_planner_item
    @planner_item = @current_user.planner_items.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ['Planner item not found'] }, status: :not_found
  end
end
