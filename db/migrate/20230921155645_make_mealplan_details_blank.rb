class MakeMealplanDetailsBlank < ActiveRecord::Migration[6.0]
  def change
    change_column_default :events, :mealplandetails, '' 
  end
end
