class AddPlayerCastCounts < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :playercount, :integer
    change_column_null :events, :integer, 0, false
    add_column :events, :castcount, :integer
    change_column_null :events, :integer, 0, false
  end
end
