class CharacterMailer < ApplicationMailer

  def send_courier
    @courier = params[:courier]
    @subject = 'Courier From ' + @courier.character.name + ' to ' + @courier.recipient
    mail(from: 'courier@mythlarp.com', to: 'courier@mythlarp.com', subject: @subject)
  end

  def send_raven
    @courier = params[:courier]
    @subject = 'Raven From ' + @courier.character.name
    mail(from: 'courier@mythlarp.com', to: 'courier@mythlarp.com', subject: @subject)
  end

  def send_oracle
    @courier = params[:courier]
    @subject = 'Oracle From ' + @courier.character.name + ' to ' + @courier.recipient
    mail(from: 'courier@mythlarp.com', to: 'courier@mythlarp.com', subject: @subject)
  end

  def send_backstory
    @backstory = params[:backstory]
    @subject = @backstory.character.name
    mail(from: 'history@mythlarp.com', to: 'history@mythlarp.com', subject: @subject)
  end
end
