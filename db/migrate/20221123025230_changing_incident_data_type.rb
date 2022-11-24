class ChangingIncidentDataType < ActiveRecord::Migration[6.0]
  def change
    change_column(:incidents, :incidentdate, :date)
    change_column(:incidents, :details, :text)
  end
end
