class CastFeedbackTable < ActiveRecord::Migration[6.0]
  def change
    create_table :eventcastfeedbacks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.string :feedback, null: false
      t.string :eventorganization, null: false
      t.string :learning, null: false
      t.string :opportunity, null: false
      t.integer :castvalue, null: false
      t.integer :returningchance, null: false
      t.string :combatvsnoncombat, null: false
      t.string :faceroles, null: false
      t.string :mechanics, null: false
      t.string :standoutplayer, null: false
      t.string :standoutnpc, null: false
      t.string :memorablemoment, null: false
      t.timestamps
    end
  end
end