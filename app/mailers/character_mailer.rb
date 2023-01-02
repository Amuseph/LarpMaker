class CharacterMailer < ApplicationMailer

  def send_courier
    @courier = params[:courier]
    @subject = 'Courier From ' + @courier.character.name + ' to ' + @courier.recipient
    mail(from: 'courier@mythlarp.com', to: 'courier@mythlarp.com', subject: @subject)
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

    puts('Taco')
    puts('Taco')
    puts(@courier)
    puts('Taco')
    puts('Taco')

    mail(from: 'courier@mythlarp.com', to: 'courier@mythlarp.com', subject: subject)
    puts('Taco')
    puts('Taco')
    puts('Taco')
    puts('Taco')
    puts('Taco')
  end

  def send_backstory
    @backstory = params[:backstory]
    @subject = @backstory.character.name
    mail(from: 'history@mythlarp.com', to: 'history@mythlarp.com', subject: @subject)
  end
end
