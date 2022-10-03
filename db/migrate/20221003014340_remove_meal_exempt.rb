class RemoveMealExempt < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :mealexempt
  end
end
