class AddRewriteToCharacters < ActiveRecord::Migration[6.0]
  def change
    add_column :characters, :rewrite, :boolean, default: 0
  end
end
