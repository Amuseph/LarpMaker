class EventMailer < ApplicationMailer

  def send_event_feedback
    @feedback = params[:eventfeedback]
    #Andrew Warzocha | (Atrius Athear) | Event: 2021-08-21
    if !@feedback.character.nil?
      @subject = @feedback.user.firstname + ' | (' + @feedback.character.name + ') | ' + @feedback.event.startdate.strftime("%m/%d/%Y")
    else
      @subject = @feedback.user.firstname + ' | (' + @feedback.event.startdate.strftime("%m/%d/%Y")
    end
    mail(from: 'no-reply@mythlarp.com', to: 'gary80740106+kyo5skwxedfyd3ua6swu@boards.trello.com', subject: @subject)
  end
end