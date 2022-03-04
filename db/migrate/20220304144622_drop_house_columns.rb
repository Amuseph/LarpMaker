class DropHouseColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :houses, :fledglingbenefit, :string
    remove_column :houses, :establishedbenefit, :string
    remove_column :houses, :bannerbenefit, :string
  end
end
