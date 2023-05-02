class ChangeNexteventplansNullable < ActiveRecord::Migration[6.0]
  def change
    change_column_null(:eventfeedbacks, :nexteventplans, true)
  end
end
