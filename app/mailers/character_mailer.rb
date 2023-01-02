class CharacterMailer < ApplicationMailer

  def send_courier
    @courier = params[:courier]
    @subject = 'Courier From ' + @courier.character.name + ' to ' + @courier.recipient
    mail(from: 'courier@mythlarp.com', to: 'courier@mythlarp.com', subject: @subject)
  end

  def send_prayer
    @courier = params[:courier]
    @subject = 'Prayer From ' + @courier.character.name + ' to ' + @courier.recipient
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
