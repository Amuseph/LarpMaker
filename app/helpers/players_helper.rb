module PlayersHelper
  def available_xp
    return current_user.explogs.where('acquiredate <= ? ', Time.now).sum(:amount)
  end

  def total_xp
    current_user.explogs.where('amount > 0').sum(:amount)
  end

  def transfer_xp(receiver, amount)
    reciever = User.find_by(email: receiver)

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