class CreateFeedbackColumns < ActiveRecord::Migration[6.0]
  def change
    create_table :feedback_columns do |t|
      add_column :eventfeedbacks, :standoutplayer, :string
      add_column :eventfeedbacks, :memorablemoment, :string
    end
  end
end
