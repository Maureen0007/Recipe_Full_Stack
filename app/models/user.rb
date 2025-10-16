class User < ApplicationRecord
    has_secure_password
    
    has_many :planner_items, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :favorite_recipes, through: :favorites, source: :recipe
    
    
    validates :email, presence: true, uniqueness: true
    
end
