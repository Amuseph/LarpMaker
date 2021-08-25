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
end
