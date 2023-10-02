class EventMailer < ApplicationMailer

  def send_event_feedback
    @feedback = params[:eventfeedback]
    #Andrew Warzocha | (Elias Athear) | Event: 2021-08-21
    @subject = @feedback.user.firstname + ' | (' + @feedback.character.name + ') | ' + @feedback.event.startdate.strftime("%m/%d/%Y")
    mail(from: 'no-reply@mythlarp.com', to: 'andrewwarzocha+w334z7hq4zywmk5hpbav@boards.trello.com', subject: @subject)
  end

  def send_event_cast_feedback
    @feedback = params[:eventcastfeedback]
    #Andrew Warzocha | Event: 2021-08-21
    subject = @feedback.user.firstname + ' | (' + @feedback.event.startdate.strftime("%m/%d/%Y")
    mail(from: 'no-reply@mythlarp.com', to: 'andrewwarzocha+w334z7hq4zywmk5hpbav@boards.trello.com', subject: subject)
  end
end