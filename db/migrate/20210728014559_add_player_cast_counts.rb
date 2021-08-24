class AddPlayerCastCounts < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :playercount, :integer
    change_column_null :events, :playercount, false, 0
    add_column :events, :castcount, :integer
    change_column_null :events, :castcount, false, 0
  end
end
