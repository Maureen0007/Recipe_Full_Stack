class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :recipe, optional: true

  validates :spoonacular_id, presence: true
  validates :title, presence: true
  validates :image, presence: true
  validates :spoonacular_id, uniqueness: { scope: :user_id, message: "has already been favorited by you" }  
end
