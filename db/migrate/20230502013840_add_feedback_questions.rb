class AddFeedbackQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :eventfeedbacks, :eventorganization, :string
    add_column :eventfeedbacks, :combatvsnoncombat, :string
    add_column :eventfeedbacks, :newplayers, :string
    add_column :eventfeedbacks, :immersion, :string
    remove_column :eventfeedbacks, :preeventcommunicationrating
    remove_column :eventfeedbacks, :eventrating
    remove_column :eventfeedbacks, :attendnextevent
    remove_column :eventfeedbacks, :sleepingrating
    remove_column :eventfeedbacks, :openingmeetingrating
    remove_column :eventfeedbacks, :closingmeetingrating
    remove_column :eventfeedbacks, :plotrating
    remove_column :eventfeedbacks, :questions
    remove_column :eventfeedbacks, :standoutplayers
  end
end