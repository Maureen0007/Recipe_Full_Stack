class AddFieldsToFavorites < ActiveRecord::Migration[8.0]
  def change
    add_column :favorites, :spoonacular_id, :string
    add_column :favorites, :title, :string
    add_column :favorites, :image, :string
  end
end
