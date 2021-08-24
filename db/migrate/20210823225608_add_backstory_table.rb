class AddBackstoryTable < ActiveRecord::Migration[6.0]
  def change
    create_table :backstories do |t|
      t.references :character, null: false, foreign_key: true
      t.string :backstory
      t.boolean :approved, null: false, default: false
      t.boolean :locked, null: false, default: false
      t.timestamps
    end
  end
end