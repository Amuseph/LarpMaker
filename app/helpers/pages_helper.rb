# frozen_string_literal: true

module PagesHelper
  def sheetsLocked
    next_event = Event.where('startdate > ? AND levelingevent', Time.now).minimum(:startdate)
    if Setting.sheets_locked
      true
    elsif Setting.sheets_auto_lock && ((next_event - Time.now.in_time_zone('Eastern Time (US & Canada)').to_date).to_i <= Setting.sheets_auto_lock_day)
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
    puts('taco')
    puts('taco')
    puts('taco')
    changelist = +""
    changelist.concat('<ul>')
    Rulebookchange.all.order('changedate desc').each do |logentry|
      changelist.concat('<li><b>', logentry.changedate.to_s, '</b> | <b>Page ', logentry.page.to_s, '</b> | ', logentry.change, '</li>')
    end
    changelist.concat('</ul>')
    return changelist.html_safe
  end
end