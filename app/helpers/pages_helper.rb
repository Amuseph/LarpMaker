# frozen_string_literal: true

module PagesHelper
  def sheetsLocked
    next_event = get_next_event
    puts('Taco2')
    puts('Taco2')
    puts('Taco2')
    puts('Taco2')
    puts(next_event)
    puts(next_event.startdate)
    puts('Taco2')
    puts('Taco2')
    puts('Taco2')
    if Setting.sheets_locked
      true
    elsif next_event.nil?
      false
    elsif Setting.sheets_auto_lock && ((next_event.startdate - Time.now.in_time_zone('Eastern Time (US & Canada)').to_date).to_i <= Setting.sheets_auto_lock_day)
      true
    end
  end

  def betweenGameSkillsLocked
    bgs_lock_time = 14

    last_event = Event.where('startdate < ? AND levelingevent', Time.now).maximum(:enddate)
    if Setting.sheets_locked
      true
    elsif sheetsLocked
      true
    elsif ((Time.now.in_time_zone('Eastern Time (US & Canada)').to_date - last_event).to_i > bgs_lock_time)
      true
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
    
    profession_count = current_user.explogs.where('name = ? and acquiredate >= ? and (description LIKE ? OR description LIKE ? OR description LIKE ?)', 'XP Store', last_played_event(@character), 'Collecting%', 'Refining%', 'Crafting%').count
    secondwind_count = current_user.explogs.where('name = ? and acquiredate >= ? and description = ?', 'XP Store', last_played_event(@character), 'Second Wind').count
    lucktoken_count = current_user.explogs.where('name = ? and acquiredate >= ? and description = ?', 'XP Store', last_played_event(@character), 'Luck Token').count
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
    else
      return submit_tag  "Purchase for #{item_cost} XP", data: {confirm: 'Are you sure?'}, :class => 'btn btn-success' 
    end
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
    if available_xp > 0
      return link_to 'Transfer XP', player_transferxp_path, class: 'text-right'
    end
  end

end