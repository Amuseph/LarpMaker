class UpdateToHouses < ActiveRecord::Migration[6.0]
  def change
    add_column :houses, :fledglingbenefit, :string
    add_column :houses, :fledglingplot, :string
    add_column :houses, :establishedbenefit, :string
    add_column :houses, :establishedplot, :string
    add_column :houses, :bannerbenefit, :string

    add_column :houses, :thane_id, :integer
    add_foreign_key :houses, :characters, column: :thane_id

  end
end
