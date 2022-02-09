class AddGuildColumns < ActiveRecord::Migration[6.0]
  def change
    add_column :guilds, :guildmaster_id, :integer
    add_foreign_key :guilds, :characters, column: :guildmaster_id
  end
end