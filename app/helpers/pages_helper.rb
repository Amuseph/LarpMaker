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

  def getEventPlayLink(event)
    "Sign up by visiting the old website: <a href='https://www.mythlarp.com/register-for-events/'>https://www.mythlarp.com/register-for-events/</a>".html_safe
  end

  def getEventCastLink(event)
    attendancecount = Eventattendance.all.where('event_id = ? and Registrationtype = ?', event.id, 'Cast').count
    if (attendancecount >= event.castcount)
      image_tag("pages/events/register_to_cast_soldout.png")
    else
      image_tag("pages/events/register_to_cast.png")
    end
  end

end
