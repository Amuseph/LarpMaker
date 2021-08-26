class AddOrderStatus < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :status, :string
    change_column_null :orders, :status, false, 'Unknown'
  end
end
