class Api::V1::RecipesController < ApplicationController
  skip_before_action :authorize_request, only: [:search, :search_by_ingredient] # optional — depends on your auth setup

   
  def search_by_ingredient
  ingredients = params[:ingredients]

  if ingredients.blank?
    return render json: { error: 'Ingredients parameter is required' }, status: :bad_request
  end

  service = SpoonacularService.new
  response = service.search_recipes_by_ingredients(ingredients)

  render json: response, status: :ok
rescue SpoonacularService::ApiError => e
  render json: { error: e.message }, status: :bad_gateway
end

  def search
    query = params[:query]
    number = params[:number] || 10

    if query.blank?
      return render json: { error: 'Query parameter is required' }, status: :bad_request
    end

    service = SpoonacularService.new
    data = service.search_recipes(query: query, number: number.to_i)

    render json: data, status: :ok
  rescue SpoonacularService::ApiError => e
    render json: { error: e.message }, status: :bad_gateway
  end
end
