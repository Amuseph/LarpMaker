class RemoveAliasAddVaccine < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :aliaslastname
    remove_column :eventattendances, :noshow
    add_column :users, :vaccine, :boolean, default: 0
  end
end
