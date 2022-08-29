# frozen_string_literal: true

module PagesHelper
  def sheetsLocked
    next_event = Event.where('enddate > ? AND levelingevent', Time.now).minimum(:startdate)
    if Setting.sheets_locked
      true
    elsif next_event.nil?
      false
    elsif Setting.sheets_auto_lock && ((next_event - Time.now.in_time_zone('Eastern Time (US & Canada)').to_date).to_i <= Setting.sheets_auto_lock_day)
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
    case item
      when 'GoodFortune'
        if (available_xp >= 250)
          return link_to 'Purchase for 250 XP', character_spendxp_path(item: 'GoodFortune'), data: {confirm: 'Are you sure?'}, method: :post, :class => 'btn btn-success' 
        else
          return "Not enough XP to purchase. Requires 250 XP."
        end
      when 'GravenMiracle'
        gravencost = gravencost()
        if available_xp >= gravencost
          return link_to "Purchase for #{gravencost} XP", character_spendxp_path(item: 'GravenMiracle'), data: {confirm: 'Are you sure?'}, method: :post, :class => 'btn btn-success' 
        else
          return "Not enough XP to purchase. Requires #{gravencost} XP."
        end
    end
  end


  def transfer_xp_link
    if available_xp > 0
      return link_to 'Transfer XP', player_transferxp_path, class: 'text-right'
    end
  end

end