class RemoveCharacterAlias < ActiveRecord::Migration[6.0]
  def change
    remove_column :characters, :alias
  end
end
