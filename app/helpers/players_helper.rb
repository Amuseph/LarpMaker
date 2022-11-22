module PlayersHelper
  include EventsHelper
  def available_xp
    current_user.explogs.where('acquiredate <= ? ', Time.now).sum(:amount)
  end

  def total_xp
    current_user.explogs.where('amount > 0').sum(:amount)
  end

  def spent_xpstore_xp
    last_played_event = get_last_played_adventure(@character)
    current_user.explogs.where('name = ? and acquiredate >= ? and Description != ?', 'XP Store', last_played_event.enddate, 'Graven Miracle').sum('amount') * -1
  end

  def transfer_exp_received(player)
    return player.explogs.where('name = ? and acquiredate >= ? and Amount > 0', 'XP Transfer', Date.today.beginning_of_year).sum('amount')
  end

  def transfer_exp_sent(player)
    return (player.explogs.where('name = ? and acquiredate >= ? and Amount < 0', 'XP Transfer', Date.today.beginning_of_year).sum('amount')) * -1
  end

  def transfer_xp(receiver, amount)
    receiver = User.where('lower(email) = ?', receiver.downcase).first
    
    @explog = Explog.new
    @explog.user_id = current_user.id
    @explog.name = 'XP Transfer'
    @explog.acquiredate = Time.now.in_time_zone('Eastern Time (US & Canada)').to_date
    @explog.description = "Transfer To " + receiver.firstname
    @explog.amount = amount * -1
    @explog.grantedby_id = current_user.id
    @explog.save!

    @explog = Explog.new
    @explog.user_id = receiver.id
    @explog.name = 'XP Transfer'
    @explog.acquiredate = Time.now.in_time_zone('Eastern Time (US & Canada)').to_date
    @explog.description = "Transfer From " + current_user.firstname
    @explog.amount = amount
    @explog.grantedby_id = current_user.id
    @explog.save!

  end

  def get_last_event_played
    return Event.joins(:eventattendances).where('enddate < ? AND levelingevent and user_id = ? and eventtype = ? and registrationtype = ?', Time.now.in_time_zone('Eastern Time (US & Canada)'), current_user.id, 'Adventure Weekend', 'Player').reorder('enddate desc').first
  end

end