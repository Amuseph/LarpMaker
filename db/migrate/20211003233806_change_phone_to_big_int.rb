class ChangePhoneToBigInt < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :phonenumber, :integer, :limit => 8
  end
end
