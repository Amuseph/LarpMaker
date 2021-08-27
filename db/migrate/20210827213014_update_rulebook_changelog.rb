class UpdateRulebookChangelog < ActiveRecord::Migration[6.0]
  def change
    add_column :rulebookchanges, :version, :string
    change_column_null :rulebookchanges, :version, false, 'Unknown'
  end
end
