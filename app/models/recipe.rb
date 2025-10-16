class Recipe < ApplicationRecord
    has_many :planner_items, dependent: :destroy
    has_many :favorited_by, through: :favorites, source: :user
    has_many :favorites, dependent: :destroy

    validates :title, presence: true
end
