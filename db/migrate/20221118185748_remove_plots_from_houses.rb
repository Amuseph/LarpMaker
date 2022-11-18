class RemovePlotsFromHouses < ActiveRecord::Migration[6.0]
  def change
    remove_column :houses, :fledglingplot
    remove_column :houses, :establishedplot
    remove_column :users, :vaccine
  end
end
