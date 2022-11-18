# frozen_string_literal: true

module PagesHelper
include EventsHelper
include PlayersHelper
  def bgs_lock_days
    14
  end

  def sheets_auto_lock_days 
    14
  end

  def get_sheets_locked
    next_event = get_next_event
    if Setting.sheets_locked
      return true
    elsif next_event.nil?
      return false
    elsif Setting.sheets_auto_lock && ((next_event.startdate - Time.now.in_time_zone('Eastern Time (US & Canada)').to_date).to_i <= sheets_auto_lock_days)
      return true
    elsif (next_event.startdate..next_event.enddate).cover?(Time.now.in_time_zone('Eastern Time (US & Canada)'))
      return true
    end
  end

  def betweenGameSkillsLocked
    if !session[:character]
      return true
    end
    last_event = get_last_played_adventure(@character)
    if Setting.sheets_locked
      return true
    elsif get_sheets_locked
      return true
    elsif last_event.nil?
      return true
    elsif ((Time.now.in_time_zone('Eastern Time (US & Canada)').to_date - last_event).to_i > bgs_lock_days)
      return true
    end
  end

  def checkActiveCharacterTab(type, tabName)
    requestedTab = if params[:tab].nil?
                     'skills'
                   else
                     params[:tab]
                   end
    return 'active' if (tabName == requestedTab) && (type == 'link')

    'show active' if (tabName == requestedTab) && (type == 'content')
  end

  def checkActiveCampTab(type, tabName)
    requestedTab = if params[:tab].nil?
                     'general'
                   else
                     params[:tab]
                   end
    return 'active' if (tabName == requestedTab) && (type == 'link')

    'show active' if (tabName == requestedTab) && (type == 'content')
  end

  def display_rulebook_changelog
    changelist = +""
    changelist = +""
    rulebookversions = Rulebookchange.distinct.order('version desc').pluck(:version)
    rulebookversions.each do |version|
      changelist.concat('<p class = "h5">Version ',version,'</p>')
      changelist.concat('<ul>')
      Rulebookchange.where(version: version).order('changedate desc, page asc').each do |logentry|
        changelist.concat('<li><b>', logentry.changedate.strftime("%m/%d/%Y"), '</b> - [Page ', logentry.page.to_s, '] ', logentry.change, '</li>')
      end
      changelist.concat('</ul>')
    end
    changelist.concat('</ul>')
    return changelist.html_safe
  end

  def gravencost
    if current_user.explogs.where('name = ? and description = ?', 'XP Store', 'Graven Miracle').exists?
      return current_user.explogs.where('name = ? and description = ?', 'XP Store', 'Graven Miracle').minimum('amount') * -2
    else
      return 500
    end
  end

  def get_xpstore_link(item)
    
    profession_count = current_user.explogs.where('name = ? and acquiredate >= ? and (description LIKE ? OR description LIKE ? OR description LIKE ?)', 'XP Store', get_last_played_adventure(@character), 'Collecting%', 'Refining%', 'Crafting%').count
    secondwind_count = current_user.explogs.where('name = ? and acquiredate >= ? and description = ?', 'XP Store', get_last_played_adventure(@character), 'Second Wind').count
    lucktoken_count = current_user.explogs.where('name = ? and acquiredate >= ? and description = ?', 'XP Store', get_last_played_adventure(@character), 'Luck Token').count
    case item
      when 'Tier1'
        item_cost = 25
      when 'Tier2'
        item_cost = 35
      when 'Tier3'
        item_cost = 50
      when 'BodyPanacea', 'SpiritPanacea', 'MindPanacea'
        item_cost = 150
      when 'Collecting', 'Refining', 'Crafting'
        item_cost = 50
      when 'SecondWind'
        item_cost = 100
      when 'LuckToken'
        item_cost = 250
      when 'GoodFortune'
        item_cost = 250
      when 'GravenMiracle'
        item_cost = gravencost()
      when 'Juniper'
        item_cost = 50
      when 'WeepingWillow'
        item_cost = 100
      else
        item_cost = 999999
    end

    if item_cost > available_xp
      return "<br>Not enough XP to purchase. Requires #{item_cost} XP.".html_safe
    elsif spent_xpstore_xp + item_cost > 500 && item != 'GravenMiracle'
      return "<br>Spending #{item_cost} would put you over the 500 XP Limit.".html_safe
    elsif ['Collecting', 'Refining', 'Crafting'].include? item and profession_count >= 1
      return '<br>You have already purchased a crafting profession'.html_safe
    elsif secondwind_count >= 1 and item == 'SecondWind'
      return '<br>You may only purchase one Second Wind per event'.html_safe
    elsif lucktoken_count >= 1 and item == 'LuckToken'
      return '<br>You may only purchase one Luck Token per event'.html_safe
    elsif item == 'Juniper' and xpstore_cabinlist_juniper.empty?
      return '<br>This cabin is not available for any future events you are registered for.'.html_safe
    elsif item == 'WeepingWillow' and xpstore_cabinlist_weepingwillow.empty?
      return '<br>This cabin is not available for any future events you are registered for.'.html_safe
    else
      return submit_tag  "Purchase for #{item_cost} XP", data: {confirm: 'Are you sure?'}, :class => 'btn btn-success' 
    end
  end

  def xpstore_cabinlist_juniper
    eventlist = []
    cabin = Cabin.find_by(name: 'Juniper')
    @character.eventattendances.joins(:event).where('startdate > ? and levelingevent = ? and eventtype = ?', Time.now, true, 'Adventure Weekend').each do | eventattendance |
      if eventattendance.cabin.nil? or eventattendance.cabin.name != 'Juniper'
        event = Event.find(eventattendance.event.id)
        if (event.eventattendances.where(cabin_id: cabin.id).count < cabin.maxplayers) || cabin.maxplayers == -1
          eventlist.push([eventattendance.event.name, eventattendance.id])
        end
      end
    end
    return eventlist
  end

  def xpstore_cabinlist_weepingwillow
    eventlist = []
    cabin = Cabin.find_by(name: 'Weeping Willow - Left')
    @character.eventattendances.joins(:event).where('startdate > ? and levelingevent = ? and eventtype = ?', Time.now, true, 'Adventure Weekend').each do | eventattendance |
      if eventattendance.cabin.nil? or eventattendance.cabin.name != 'Weeping Willow - Left'
        event = Event.find(eventattendance.event.id)
        if (event.eventattendances.where(cabin_id: cabin.id).count < cabin.maxplayers) || cabin.maxplayers == -1
          eventlist.push([eventattendance.event.name, eventattendance.id])
        end
      end
    end
    return eventlist
  end

  def xpstore_tier1_skills
    skilllist = []

    @character.characterclass.skillgroups.where('skillgroups.playeravailable = true').each do |skillgroup|
      skills = @character.characterclass.skills.where('skills.playeravailable = true and skills.skillgroup_id = ? and tier = 1', skillgroup.id)
      skills.each do |skill|
        if skill.resttype.name != 'Permanent'
          skilllist.push([skill.name, skill.id]) if has_skill_prereq(@character, skill)
        end
      end
    end
    return skilllist
  end

  def xpstore_tier2_skills
    skilllist = []

    @character.characterclass.skillgroups.where('skillgroups.playeravailable = true').each do |skillgroup|
      skills = @character.characterclass.skills.where('skills.playeravailable = true and skills.skillgroup_id = ? and tier = 2', skillgroup.id)
      skills.each do |skill|
        if skill.resttype.name != 'Permanent'
          skilllist.push([skill.name, skill.id]) if has_skill_prereq(@character, skill)
        end
      end
    end
    return skilllist
  end

  def xpstore_tier3_skills
    skilllist = []

    @character.characterclass.skillgroups.where('skillgroups.playeravailable = true').each do |skillgroup|
      skills = @character.characterclass.skills.where('skills.playeravailable = true and skills.skillgroup_id = ? and tier = 3', skillgroup.id)
      skills.each do |skill|
        if skill.resttype.name != 'Permanent'
          skilllist.push([skill.name, skill.id]) if has_skill_prereq(@character, skill)
        end
      end
    end
    return skilllist
  end

  def xpstore_collecting
    professionlist = []

    Professiongroup.where('playeravailable = true and name = ?', 'Collector').each do |professiongroup|
      professiongroup.professions.where('playeravailable = true and name like ?', 'Novice%').each do |profession|
        next if @character.professions.where(name: profession.name).count >= 1
        professionlist.push([profession.name, profession.id])
      end
    end
    return professionlist
  end

  def xpstore_refining
    professionlist = []

    Professiongroup.where('playeravailable = true and name = ?', 'Refining').each do |professiongroup|
      professiongroup.professions.where('playeravailable = true and name like ?', 'Novice%').each do |profession|
        next if @character.professions.where(name: profession.name).count >= 1
        professionlist.push([profession.name, profession.id])
      end
    end
    return professionlist
  end

  def xpstore_crafting
    professionlist = []

    Professiongroup.where('playeravailable = true and name = ?', 'Crafting').each do |professiongroup|
      professiongroup.professions.where('playeravailable = true and name like ?', 'Novice%').each do |profession|
        next if @character.professions.where(name: profession.name).count >= 1
        professionlist.push([profession.name, profession.id])
      end
    end
    return professionlist
  end

  def transfer_xp_link
    if get_last_event_played.nil?
      return
    elsif !get_last_event_played.enddate.prev_month(6).past?
      return
    elsif current_user.usertype == 'Cast'
      return
    elsif available_xp > 0
      return link_to 'Transfer XP', player_transferxp_path, class: 'text-right'
    end
  end

  def get_marquee_text
    next_event = get_next_event
    last_event = get_last_event
    if get_sheets_locked
      return ("<p class=""h2"">Sheets have been locked while we prepare for game! </p>").html_safe
    end

    if !next_event.nil?
      sheets_lock_in =  (next_event.startdate - Time.now.in_time_zone('Eastern Time (US & Canada)').to_date).to_i - sheets_auto_lock_days
  
      if sheets_lock_in <= 14
        hours_till_lock = ((DateTime.tomorrow.in_time_zone('Eastern Time (US & Canada)').to_time - Time.now.in_time_zone('Eastern Time (US & Canada)')) / 1.hour).to_i + 1
        if sheets_lock_in > 1
          return ("<p class=""h2"">Character Sheets lock in %s day(s)! </p>" % (sheets_lock_in)).html_safe
        else
          return ("<p class=""h2"">Character Sheets lock in less than %s hour(s)! </p>" % (hours_till_lock)).html_safe
        end
      end
    end
    
    if !betweenGameSkillsLocked
      return ("<p class=""h2"">Between Game Skills / Couriers / Feedback are due in less than %s days! </p>" % (bgs_lock_days - (Time.now.in_time_zone('Eastern Time (US & Canada)').to_date - last_event.enddate).to_i)).html_safe
    end

    return
  end

end