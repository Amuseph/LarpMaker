class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :description
      t.string :token
      t.integer :amount
      t.timestamps
    end
  end
end
