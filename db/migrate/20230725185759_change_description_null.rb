class ChangeDescriptionNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null(:events, :description, true)
    
  end
end
