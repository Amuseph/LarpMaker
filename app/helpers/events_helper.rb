# frozen_string_literal: true
module EventsHelper
  def canUpdateCabin()
    if !sheetsLocked && (@myeventattendance.registrationtype == 'Player') && @myeventattendance.event.startdate > Date.today
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
    feedback_start_date = Date.new(2021,9,1) # Do not touch. This is when feedback got migrated to the new site
    eventattendance = event.eventattendances.find_by(user_id: current_user)
   
    if event.startdate > Date.today.in_time_zone('Eastern Time (US & Canada)').to_date
      return
    elsif event.startdate < feedback_start_date # Remove me after 30 days
      return
    elsif !Eventfeedback.find_by('event_id = ? and user_id = ?', event.id, current_user.id).nil?
      return link_to 'View Your Feedback', event_viewfeedback_path(event.id)
    elsif ((Date.today.in_time_zone('Eastern Time (US & Canada)').to_date - event.enddate).to_i < 30) #change this to 30 later
        return link_to 'Submit Feedback', event_submitfeedback_path(event.id)
    else
      return
    end
  end

  def add_feedback_exp(event, eventattendance)
    event_feedback_exp_days = 14
    if ((Date.today.in_time_zone('Eastern Time (US & Canada)').to_date - event.enddate).to_i >= event_feedback_exp_days)
      @explog = Explog.new
      @explog.user_id = eventattendance.user_id
      @explog.name = 'Feedback'
      @explog.acquiredate = Date.today.in_time_zone('Eastern Time (US & Canada)').to_date
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
      return (link_to(image_tag("pages/events/register_to_play.png"), event_playersignup_path(event.id))) + ('<br> Only ' + (event.playercount - attendancecount).to_s + ' slots remain').html_safe
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
    if !event.mealplan?
      return
    elsif @eventattendance.registrationtype == 'Cast' || @eventattendance.mealplan.nil? || @eventattendance.mealplan.empty?
      return link_to 'View Meal Plan', event_mealplan_path(event.id)
    else
      return link_to @eventattendance.mealplan, event_mealplan_path(event.id)
    end

  end

  def get_mealplan_signup(event)
    @eventattendance = Eventattendance.find_by(user_id: current_user, event_id: event.id)
    meal_plan_cutoff_days = 5

    if (@eventattendance.mealplan.nil? || @eventattendance.mealplan.empty? || @eventattendance.mealplan == 'Brew of the Month Club' ) && (event.startdate - meal_plan_cutoff_days > Date.today) && (@eventattendance.registrationtype == 'Player')
      return (render partial: 'event/partials/selectmealplan')
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

  def get_mealplan_cost(event, eventattendance, option)
    if (eventattendance.mealplan.nil? or eventattendance.mealplan.empty?) && (option == 'Meat' or option == 'Vegan')
      return event.mealplancost
    elsif (eventattendance.mealplan.nil? or eventattendance.mealplan.empty?) && option == 'Brew of the Month Club'
      return 5
    elsif eventattendance.mealplan == 'Brew of the Month Club'
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
    days_till_lockout = (event.startdate - Date.today.in_time_zone('Eastern Time (US & Canada)').to_date).to_i - Setting.sheets_auto_lock_day
    if user_signed_in?
      if (days_till_lockout <= 0)
        return event.atdoorcost
      elsif (current_user.eventattendances.where(registrationtype: 'Player').count == 0)
        return event.newplayerprice
      else
        return event.earlybirdcost
      end
    else
      return event.atdoorcost
    end
  end

  def get_event_price_details(event)
    days_till_lockout = (event.startdate - Date.today.in_time_zone('Eastern Time (US & Canada)').to_date).to_i - Setting.sheets_auto_lock_day
    early_bird_date = event.startdate - Setting.sheets_auto_lock_day
    event_price_html = ''
    if (days_till_lockout > 0)
      event_price_html += '<b>New Player Early Bird Rate:</b> $' + event.newplayerprice.to_s + '<br>'
      event_price_html += '<b>Early Bird Pricing:</b> $'+ event.earlybirdcost.to_s + '<br>'
      event_price_html +=  'Early Bird pricing goes till ' + early_bird_date.strftime("%m/%d/%Y") + ' - (' + days_till_lockout.to_s + ' days remain!)<br>'
    end
    event_price_html += '<b>Standard Pricing:</b> $' + event.atdoorcost.to_s + '<br>'
    return event_price_html.html_safe      
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
