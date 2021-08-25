# frozen_string_literal: true
module EventsHelper
  def canUpdateCabin()
    if !sheetsLocked && (@myeventattendance.registrationtype == 'Player') && @myeventattendance.event.startdate > Time.now
      true
    else
      false
    end
  end

  def cabinResident(cabinassignment)
    if (cabinassignment.character) then 
      if cabinassignment.character.alias.present?
        return cabinassignment.character.alias
      else
        return cabinassignment.character.name.partition(" ").first 
      end
    else
      return 'Player: ' + cabinassignment.user.firstname
    end
  end

  def add_event_xp(event, eventattendance)
    @explog = Explog.new
    @explog.user_id = eventattendance.user_id
    @explog.name = 'Event'
    @explog.acquiredate = event.startdate
    @explog.description = "Exp for attending Event \"#{eventattendance.event.name}\" as a #{eventattendance.registrationtype}"
    @explog.amount = event.eventexp
    @explog.grantedby_id = current_user.id
    @explog.save!
  end

  def getEventPlayLink(event)
    attendancecount = Eventattendance.all.where('event_id = ? and Registrationtype = ?', event.id, 'Player').count
    if (attendancecount >= event.playercount)
      return image_tag("pages/events/register_to_play.png")
    else
      return link_to(image_tag("pages/events/register_to_play.png"), event_playersignup_path(event.id))
    end
  end

  def getEventCastLink(event)
    attendancecount = Eventattendance.all.where('event_id = ? and Registrationtype = ?', event.id, 'Cast').count
    if (attendancecount >= event.castcount)
      return image_tag("pages/events/register_to_cast_soldout.png")
    else
      return link_to(image_tag("pages/events/register_to_cast.png"), event_castsignup_path(event.id))
    end
  end

  def GetCastSignupLink(event)
    if !user_signed_in?
      return 'Please create an account before purchasing an event'
    end
    @eventattendance = Eventattendance.find_by(user_id: current_user, event_id: event.id)
      if @eventattendance.nil?
        return link_to 'Sign Up To Cast', event_castsignup_path, data: { confirm: 'Thank you for signing up to cast. Please confirm?'}, method: :post, id: 'signuplink'
      else
        return ("<b>You are already registered to play as " + @eventattendance.registrationtype + '</b>').html_safe
      end
  end

  def GetPlayerSignupLink(event)
    if !user_signed_in?
      return 'Please create an account before purchasing an event'
    end
    @eventattendance = Eventattendance.find_by(user_id: current_user, event_id: event.id)
    if @eventattendance.nil?
      return (render partial: 'event/partials/buyevent')
    else
      return ("<b>You are already registered to play as " + @eventattendance.registrationtype + '</b>').html_safe
    end
  end

  def get_event_price(event)
    if ((event.startdate - Time.now.in_time_zone('Eastern Time (US & Canada)').to_date).to_i <= Setting.sheets_auto_lock_day)
      return event.atdoorcost
    else
      puts(event.earlybirdcost)
      return event.earlybirdcost
    end
  end

  def add_user_to_event(user, event)
    @eventattendance = Eventattendance.new
    @eventattendance.event_id = event.id
    @eventattendance.user_id = user.id
    @eventattendance.registrationtype = 'Player'

    if (@eventattendance.character_id.nil?) && (@eventattendance.user.characters.where(status: 'Active').count == 1) && (@eventattendance.registrationtype == 'Player')
      @eventattendance.character_id = @eventattendance.user.characters.find_by(status: 'Active').id
    end

    if @eventattendance.save!
      add_event_xp(event, @eventattendance)
    end
  end
end