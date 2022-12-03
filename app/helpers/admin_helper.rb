
module AdminHelper
  require 'active_record/errors'
  include EventsHelper

  def process_banklog_upload(line, data)
    if data.length() != 3
      return "Line #{line} either has too many or too few elements: #{data}"
    end
    if data[0].empty?
      return "Line #{line} does not have any Player ID: #{data}"
    end
    if Integer(data[0], exception: false).nil?
      return "Line #{line} does not have a valid number for Player ID: #{data}"
    end
    if data[1].empty?
      return "Line #{line} does not have a name for the Bank Log: #{data}"
    end
    if data[2].empty?
      return "Line #{line} does not have an amount for the XP: #{data}"
    end
    if Integer(data[2], exception: false).nil?
      return "Line #{line} does not have an valid amount for the XP: #{data}"
    end

    begin
      user = User.find(data[0])
    rescue
      return "Line #{line} does not appear to have a valid Player ID: #{data}"
    end

    begin
      character = Eventattendance.joins(:event).where('user_id = ? and Registrationtype = ? and enddate < ? and levelingevent', user.id, 'Player', Date.today).order("enddate DESC").first.character
      if character.nil? or character.blank?
        return "Line #{line} this player does not have a character that attended a prior event: #{data}"
      end
    rescue
      return "Line #{line} error in getting last played character: #{data}"
    end

    begin
      banklog = Banklog.new
      banklog.character_id = character.id
      banklog.name = data[1]
      banklog.acquiredate = Time.now
      banklog.amount = data[2].strip
      banklog.grantedby_id = current_user.id
      banklog.save!
      return "Line #{line} upload successful"
    rescue
      return "Line #{line} error in Updating Bank Log: #{data}"
    end
  end

  def process_explog_upload(line, data)
    if data.length() != 4
      return "Line #{line} either has too many or too few elements: #{data}"
    end
    if data[0].empty?
      return "Line #{line} does not have any Player ID: #{data}"
    end
    if Integer(data[0], exception: false).nil?
      return "Line #{line} does not have a valid number for Player ID: #{data}"
    end
    if data[1].empty?
      return "Line #{line} does not have a name for the XP: #{data}"
    end
    if data[2].empty?
      return "Line #{line} does not have a description for the XP: #{data}"
    end
    if data[3].empty?
      return "Line #{line} does not have an amount for the XP: #{data}"
    end
    if Integer(data[3], exception: false).nil?
      return "Line #{line} does not have an valid amount for the XP: #{data}"
    end

    begin
      user = User.find(data[0])
    rescue
      return "Line #{line} does not appear to have a valid Player ID: #{data}"
    end

    begin
      explog = Explog.new
      explog.user_id = data[0]
      explog.name = data[1]
      explog.acquiredate = Time.now
      explog.description = data[2].strip
      explog.amount = data[3].strip
      explog.grantedby_id = current_user.id
      explog.save!
      return "Line #{line} upload successful"
    rescue
      return "Line #{line} error in assigning XP: #{data}"
    end
  end
end