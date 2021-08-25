class AddNewPlayerCost < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :newplayerprice, :integer
    change_column_null :events, :newplayerprice, false, 75
  end
end
