class RemoveRecipeIdFromFavorites < ActiveRecord::Migration[8.0]
  def change
    remove_column :favorites, :recipe_id, :integer
  end
end
