class WaiverSignBoolean < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :waiver, :boolean, default: 0
  end
end
