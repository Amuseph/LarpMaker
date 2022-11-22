class AddIncidentTable < ActiveRecord::Migration[6.0]
  def change
    create_table :incidents do |t|
      t.references :user, null: false, foreign_key: true
      t.references :reportedby, null: false, foreign_key: { to_table: :users }
      t.date :incidentdate, default: -> { 'CURRENT_TIMESTAMP' }
      t.string :details, null: false
      t.timestamps
    end
  end
end
