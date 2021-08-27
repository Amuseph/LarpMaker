class AddingRulebookChangelog < ActiveRecord::Migration[6.0]
  def change
    create_table :rulebookchanges do |t|
      t.integer :page, null: false
      t.string :change, null: false
      t.date :changedate, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamps
    end
  end
end
