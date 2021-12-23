class AddSeasonToEvent < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :season, :string
    change_column_null :events, :season, false, 'Spring'
  end
end
