class PlannerItem < ApplicationRecord
  belongs_to :user
  belongs_to :recipe, optional: true


  validates :spoonacular_id, :title, :meal_type, :planned_date, presence: true
  validates :meal_type, inclusion: { in: %w[breakfast lunch dinner] }
end
