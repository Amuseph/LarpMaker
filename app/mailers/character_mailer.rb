class CharacterMailer < ApplicationMailer

  def send_courier
    @courier = params[:courier]
    @subject = 'Courier From ' + @courier.character.name + ' to ' + @courier.recipient
    mail(from: 'courier@mythlarp.com', to: 'andrewwarzocha+84aiyc6tzpqifqvyedgt@boards.trello.com', subject: @subject)
  end

  def send_between_game
    @courier = params[:courier]

    case @courier.couriertype
      when 'Oracle'
        subject = 'Oracle From ' + @courier.character.name + ' to ' + @courier.recipient
      when 'Scry'
        subject = 'Scry From ' + @courier.character.name

      when 'Raven'
        subject = 'Raven From ' + @courier.character.name
      when 'Other'
        subject = 'Between Game Skill From ' + @courier.character.name
    end

    mail(from: 'courier@mythlarp.com', to: 'andrewwarzocha+84aiyc6tzpqifqvyedgt@boards.trello.com', subject: subject)
  end

  def send_backstory
    @backstory = params[:backstory]
    @subject = @backstory.character.name
    mail(from: 'andrewwarzocha+s11ygfpv6ae3jxics64v@boards.trello.com', to: 'andrewwarzocha+s11ygfpv6ae3jxics64v@boards.trello.com', subject: @subject)
  end
end
