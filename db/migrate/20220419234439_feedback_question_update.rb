class FeedbackQuestionUpdate < ActiveRecord::Migration[6.0]
  def change
    change_column_null(:eventfeedbacks, :preeventcommunicationrating, true, "1")
    change_column_null(:eventfeedbacks, :eventrating, true, "1")
    change_column_null(:eventfeedbacks, :attendnextevent, true, "1")
    change_column_null(:eventfeedbacks, :sleepingrating, true, "1")
    change_column_null(:eventfeedbacks, :openingmeetingrating, true, "1")
    change_column_null(:eventfeedbacks, :closingmeetingrating, true, "1")
    change_column_null(:eventfeedbacks, :plotrating, true, "1")
    change_column_null(:eventfeedbacks, :questions, true, "N/A")
    change_column_null(:eventfeedbacks, :standoutplayers, true, "N/A")
  end
end