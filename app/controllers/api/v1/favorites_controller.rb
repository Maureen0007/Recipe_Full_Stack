class Api::V1::FavoritesController < ApplicationController
  before_action :authorize_request
  before_action :set_recipe, only: [:destroy]   # ✅ remove :create here

  def index
    @favorites = @current_user.favorites
    render json: @favorites, status: :ok
  end

  def create
    favorite = @current_user.favorites.find_or_initialize_by(spoonacular_id: params[:spoonacular_id])
    favorite.title = params[:title]
    favorite.image = params[:image]

    if favorite.save
      render json: favorite, status: :created
    else
      render json: { errors: favorite.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    favorite = @current_user.favorites.find_by(recipe: @recipe)

    if favorite
      favorite.destroy
      render json: { message: 'Recipe removed from favorites' }, status: :ok
    else
      render json: { errors: ['Favorite not found'] }, status: :not_found
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ['Recipe not found'] }, status: :not_found
  end
end
