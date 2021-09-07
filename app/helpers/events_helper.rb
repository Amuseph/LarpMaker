# frozen_string_literal: true
module EventsHelper
  def canUpdateCabin()
    if !sheetsLocked && (@myeventattendance.registrationtype == 'Player') && @myeventattendance.event.startdate > Time.now
      true
    else
      false
    end
  end

  def cabin_resident(cabinassignment)
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

  def get_feedback_link(event)
    eventattendance = event.eventattendances.find_by(user_id: current_user)
    if event.startdate > Time.now.in_time_zone('Eastern Time (US & Canada)').to_date
      return
    elsif ((event.enddate - Time.now.in_time_zone('Eastern Time (US & Canada)').to_date).to_i >= -5) #change this to 30 later
      if Eventfeedback.find_by('event_id = ? and user_id = ?', event.id, current_user.id).nil?
        return link_to 'Submit Feedback', event_submitfeedback_path(event.id)
      else
        return link_to 'View Your Feedback', event_viewfeedback_path(event.id)
      end
    else
      return
    end
  end

  def add_feedback_exp(event, eventattendance)
    if ((event.enddate - Time.now.in_time_zone('Eastern Time (US & Canada)').to_date).to_i >= -14)
      @explog = Explog.new
      @explog.user_id = eventattendance.user_id
      @explog.name = 'Feedback'
      @explog.acquiredate = Time.now.in_time_zone('Eastern Time (US & Canada)').to_date
      @explog.description = "Exp for Feedback Letter"
      @explog.amount = event.feedbackexp
      @explog.grantedby_id = current_user.id
      @explog.save!
    end
  end


  def add_event_exp(event, eventattendance)
    @explog = Explog.new
    @explog.user_id = eventattendance.user_id
    @explog.name = 'Event'
    @explog.acquiredate = event.startdate
    @explog.description = "Exp for attending Event \"#{eventattendance.event.name}\" as a #{eventattendance.registrationtype}"
    @explog.amount = event.eventexp
    @explog.grantedby_id = current_user.id
    @explog.save!
  end

  def get_event_player_link(event)
    attendancecount = Eventattendance.all.where('event_id = ? and Registrationtype = ?', event.id, 'Player').count
    if get_event_price(event) <= 0
      return 'An error has occured. Please reach out to support@mythlarp.com'
    elsif (attendancecount >= event.playercount)
      return image_tag("pages/events/register_to_play_soldout.png")
    else
      return link_to(image_tag("pages/events/register_to_play.png"), event_playersignup_path(event.id))
    end
  end

  def get_event_cast_link(event)
    attendancecount = Eventattendance.all.where('event_id = ? and Registrationtype = ?', event.id, 'Cast').count
    if (attendancecount >= event.castcount)
      return image_tag("pages/events/register_to_cast_soldout.png")
    else
      return link_to(image_tag("pages/events/register_to_cast.png"), event_castsignup_path(event.id))
    end
  end

  def get_mealplan_link(event)
    @eventattendance = Eventattendance.find_by(user_id: current_user, event_id: event.id)
    if @eventattendance.registrationtype == 'Cast'
      return link_to 'Meal Provided', event_mealplan_path(event.id)
    elsif (@eventattendance.mealplan.nil? || @eventattendance.mealplan.empty?) && event.mealplan? && event.startdate > Time.now
      return link_to 'Buy A Meal Plan', event_mealplan_path(event.id)
    else
      return link_to @eventattendance.mealplan, event_mealplan_path(event.id)
    end

  end

  def get_mealplan_signup(event)
    @eventattendance = Eventattendance.find_by(user_id: current_user, event_id: event.id)
    if (@eventattendance.mealplan.nil? || @eventattendance.mealplan.empty?) && event.mealplan? && event.startdate > Time.now && @eventattendance.registrationtype == 'Player'
      return (render partial: 'event/partials/buymealplan')
    elsif @eventattendance.mealplan. == 'Brew of the Month Club'
      return (render partial: 'event/partials/buymealplan')
    end
  end

  def get_resident_players(event,area)
    cabinlist = +""
    Cabin.all.where(location: area).where.not(name: 'Cast Cabin').each do |cabin|
      cabinlist.concat('<b>', cabin.name, '</b>')
      cabinlist.concat('<ul>')
        event.eventattendances.where(registrationtype: 'Player', cabin: Cabin.all.find_by(name: cabin.name)).each do |cabinassignment|
          cabinlist.concat('<li>', cabin_resident(cabinassignment))
        end
      cabinlist.concat('</ul>')
    end
    return cabinlist.html_safe
  end

  def get_homeless_players(event)
    cabinlist = +""
    cabinlist.concat('<ul>')
      event.eventattendances.where(registrationtype: 'Player', cabin: nil).each do |cabinassignment|
        cabinlist.concat('<li>', cabin_resident(cabinassignment))
      end
    cabinlist.concat('</ul>')
    return cabinlist.html_safe
  end

  def get_mealplan_cost(event,eventattendance)
    if eventattendance.mealplan.nil? or eventattendance.mealplan.empty?
      return event.mealplancost
    elsif eventattendance.mealplan = 'Brew of the Month Club'
      return event.mealplancost - 5
    end
    return event.mealplancost
  end

  def get_cast_signup(event)
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

  def get_player_signup(event)
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

  def get_event_status(event)
    if !user_signed_in?
      return 'Login to the site in order to see your event status and sign up!'
    end
    @eventattendance = Eventattendance.find_by(user_id: current_user, event_id: event.id)
    if @eventattendance.nil?
      return ('<font color="red" size="5">You are not signed up for this event. Register today!</font>').html_safe
    else
      return ("You are already registered to play as " + @eventattendance.registrationtype).html_safe
    end
  end

  def get_event_price(event)
    if user_signed_in?
      if (current_user.eventattendances.where(registrationtype: 'Player').count == 0) && (user_signed_in?)
        return event.newplayerprice
      end
    end
    if ((event.startdate - Time.now.in_time_zone('Eastern Time (US & Canada)').to_date).to_i <= Setting.sheets_auto_lock_day)
      return event.atdoorcost
    else
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
      add_event_exp(event, @eventattendance)
    end
  end
end
