class ZipCodeToString < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :zipcode, :string
  end
end
