module PlayersHelper
  include EventsHelper
  def available_xp
    current_user.explogs.where('acquiredate <= ? ', Time.now).sum(:amount)
  end

  def total_xp
    current_user.explogs.where('amount > 0').sum(:amount)
  end

  def spent_xpstore_xp
    current_user.explogs.where('name = ? and acquiredate >= ? and Description != ?', 'XP Store', last_played_event(@character), 'Graven Miracle').sum('amount') * -1
  end

  def transfered_xp(player)
    last_event = Event.where('enddate < ? AND levelingevent', Time.now).reorder('enddate desc').first
    first_event_of_season = Event.where('extract(year from startdate) = ? AND levelingevent and season = ?', last_event.startdate.year, last_event.season).reorder('startdate ASC').first
    player.explogs.where('name = ? and acquiredate >= ? and Amount > 0', 'XP Transfer', first_event_of_season.startdate).sum('amount')
  end

  def transfer_xp(receiver, amount)
    reciever = User.where('lower(email) = ?', receiver.downcase).first
    
    @explog = Explog.new
    @explog.user_id = current_user.id
    @explog.name = 'XP Transfer'
    @explog.acquiredate = Time.now.in_time_zone('Eastern Time (US & Canada)').to_date
    @explog.description = "Transfer To " + reciever.firstname
    @explog.amount = amount * -1
    @explog.grantedby_id = current_user.id
    @explog.save!

    @explog = Explog.new
    @explog.user_id = reciever.id
    @explog.name = 'XP Transfer'
    @explog.acquiredate = Time.now.in_time_zone('Eastern Time (US & Canada)').to_date
    @explog.description = "Transfer From " + current_user.firstname
    @explog.amount = amount
    @explog.grantedby_id = current_user.id
    @explog.save!

  end
end