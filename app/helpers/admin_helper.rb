
module AdminHelper
  require 'active_record/errors'

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
      explog = Banklog.new
      explog.character_id = data[0]
      explog.name = data[1]
      explog.acquiredate = Time.now.in_time_zone('Eastern Time (US & Canada)').to_date
      explog.amount = data[2].strip
      explog.grantedby_id = current_user.id
      explog.save!
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
      explog.acquiredate = Time.now.in_time_zone('Eastern Time (US & Canada)').to_date
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