class AddFeedbackLetter < ActiveRecord::Migration[6.0]
  def change
    create_table :eventfeedbacks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :character, null: true, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.integer :preeventcommunicationrating, null: false
      t.integer :eventrating, null: false
      t.integer :attendnextevent, null: false
      t.integer :sleepingrating, null: false
      t.integer :openingmeetingrating, null: false
      t.integer :closingmeetingrating, null: false
      t.integer :plotrating, null: false
      t.string :feedback, null: false
      t.string :questions, null: false
      t.string :standoutplayers, null: false
      t.string :standoutnpc, null: false
      t.string :charactergoals, null: false
      t.string :charactergoalactions, null: false
      t.string :whatdidyoudo, null: false
      t.string :nexteventplans, null: false
      t.string :professions, null: false
      t.timestamps
    end
  end
end