class CreatePlannerItems < ActiveRecord::Migration[8.0]
  def change
    create_table :planner_items do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :spoonacular_id
      t.string :title
      t.string :image
      t.string :meal_type
      t.date :planned_date

      t.timestamps
    end
  end
end
