class AddBankLogTable < ActiveRecord::Migration[6.0]
  def change
    create_table :banklogs do |t|
      t.references :character, null: false, foreign_key: true
      t.datetime :acquiredate, default: -> { 'CURRENT_TIMESTAMP' }
      t.string :name, null: false
      t.integer :amount, null: false
      t.references :grantedby, null: false, foreign_key: { to_table: :users }   
      t.timestamps
    end
  end
end