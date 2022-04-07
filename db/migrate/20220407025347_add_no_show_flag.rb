class AddNoShowFlag < ActiveRecord::Migration[6.0]
  def change
    add_column :eventattendances, :noshow, :boolean, default: 0
  end
end
