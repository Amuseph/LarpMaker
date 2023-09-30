# frozen_string_literal: true
module EventsHelper

  def early_bird_days
    return 14
  end

  def has_cabin(eventattendance)
    if eventattendance.registrationtype == 'Player'
      return true
    else
      return false
    end
  end

  def get_cabin_link(eventattendance)
    if eventattendance.cabin.present?
      if can_update_cabin(eventattendance)
        return link_to eventattendance.cabin.name, event_updatecabin_path(@event), remote: true
      else
        return eventattendance.cabin.name
      end
    else
      if can_update_cabin(eventattendance)
        return link_to 'None - Update Now', event_updatecabin_path(@event), remote: true
      else
        return 'None'
      end
    end
  end

  def can_update_cabin(eventattendance)
    if !get_sheets_locked && (eventattendance.registrationtype == 'Player') && eventattendance.event.startdate > Date.today
      return true
    else
      return false
    end
  end

  def cabin_resident(cabinassignment)
    if (cabinassignment.character) then 
      return cabinassignment.character.get_first_name
    else
      return 'Player: ' + cabinassignment.user.firstname
    end
  end

  def get_feedback_link(event)
    eventattendance = event.eventattendances.find_by(user_id: current_user)

    if event.startdate > Time.now.in_time_zone('Eastern Time (US & Canada)').to_date
      return
    elsif !event.levelingevent
      return
    elsif !Eventfeedback.find_by('event_id = ? and user_id = ?', event.id, current_user.id).nil?
      if event.startdate <= Date.parse('20-05-2023') #Change me to 08
        return link_to 'View Your Feedback', event_viewoldfeedback_path(event.id)
      elsif event.startdate <= Date.parse('01-10-2023') #Change me to 08
        return link_to 'View Your Feedback', event_viewfeedback_path(event.id)
      else
        if eventattendance.registrationtype == 'Player'
          return link_to 'View Your Feedback', event_viewfeedback_path(event.id)
        elsif eventattendance.registrationtype == 'Cast'
          return link_to 'View Your Feedback', event_viewcastfeedback_path(event.id)
        end
        
      end
    elsif (((Time.now.in_time_zone('Eastern Time (US & Canada)').to_date - event.enddate).to_i < 30) and not eventattendance.noshow)
        if eventattendance.registrationtype == 'Player'
          return link_to 'Submit Player Feedback', event_submitfeedback_path(event.id)
        elsif eventattendance.registrationtype == 'Cast'
          return link_to 'Submit Cast Feedback', event_submitcastfeedback_path(event.id)
        end
    else
      return
    end
  end

  def add_feedback_exp(event, eventattendance)
    event_feedback_exp_days = 14
    
    if ((Time.now.in_time_zone('Eastern Time (US & Canada)').to_date - event.enddate).to_i <= event_feedback_exp_days)
      explog = Explog.new
      explog.user_id = eventattendance.user_id
      explog.name = 'Feedback Letter'
      explog.acquiredate = Time.now.to_date
      explog.description = "Exp for Feedback Letter - " + event.name
      explog.amount = event.feedbackexp
      explog.grantedby_id = eventattendance.user_id
      explog.save!
    end
  end


  def add_event_exp(event, eventattendance)
    season_pass_exp = 100
    year_of_season = event.startdate.year
    first_event_of_season = Event.reorder('startdate ASC').find_by("season = ? and extract(year from startdate) = ?", event.season, year_of_season)
    days_till_first_lockout = (first_event_of_season.startdate - Time.now.in_time_zone('Eastern Time (US & Canada)').to_date).to_i - early_bird_days

    if event.eventexp > 0
      @explog = Explog.new
      @explog.user_id = eventattendance.user_id
      @explog.name = 'Event'
      @explog.acquiredate = event.startdate
      @explog.description = "Exp for attending Event \"#{eventattendance.event.name}\" as a #{eventattendance.registrationtype}"
      @explog.amount = event.eventexp
      @explog.grantedby_id = current_user.id
      @explog.save!
    end

    if eventattendance.registrationtype == 'Player' && days_till_first_lockout > 0
      event_count_of_season = Event.where("season = ? and extract(year from startdate) = ?", @event.season, year_of_season).count
      player_event_count_of_season = Event.joins(:eventattendances).where("user_id = ? and season = ? and registrationtype = ? and extract(year from startdate) = ?", eventattendance.user, @event.season, 'Player', year_of_season).count
      if event_count_of_season == player_event_count_of_season
        @explog = Explog.new
        @explog.user_id = eventattendance.user_id
        @explog.name = 'Season Pass'
        @explog.acquiredate = Time.now.to_date
        @explog.description = "Season Pass Bonus #{@event.season} - #{year_of_season}"
        @explog.amount = season_pass_exp * player_event_count_of_season
        @explog.grantedby_id = current_user.id
        @explog.save!
      end
    end
  end
  
  def get_event_player_link(event)
    attendancecount = Eventattendance.all.where('event_id = ? and Registrationtype = ?', event.id, 'Player').count
    if get_event_price(event) <= 0
      return 'An error has occured. Please reach out to support@mythlarp.com'
    elsif (attendancecount >= event.playercount)
      return image_tag("pages/events/register_to_play_soldout.png", :class => "img-fluid mx-auto")
    elsif (event.startdate - Time.now.in_time_zone('Eastern Time (US & Canada)').to_date <= 7)
      return image_tag("pages/events/register_to_play_soldout.png", :class => "img-fluid mx-auto")
    else
      return (link_to(image_tag("pages/events/register_to_play.png", :class => "img-fluid mx-auto"), event_playersignup_path(event.id))) + ('<br> Only ' + (event.playercount - attendancecount).to_s + ' slots remain').html_safe
    end
  end

  def get_feedback_rank_string(ranking, type)
    if type == 'YesNo'
      case ranking
      when 0
        "Yes"
      when 1
        "No"
      end
    else
      case ranking
      when 1
        "Very Satisfied"
      when 2
        "Somewhat Satisfied"
      when 3
        "Neither Satisfied or Dissatisfied"
      when 4
        "Somewhat Dissatisfied"
      when 5
        "Very Dissatisfied"
      end
    end
    
  end

  def get_event_cast_link(event)
    attendancecount = Eventattendance.all.where('event_id = ? and Registrationtype = ?', event.id, 'Cast').count
    if (attendancecount >= event.castcount)
      return image_tag("pages/events/register_to_cast_soldout.png", :class => "img-fluid mx-auto")
    else
      return link_to(image_tag("pages/events/register_to_cast.png", :class => "img-fluid mx-auto"), event_castsignup_path(event.id)) + ('<br> Only ' + (event.castcount - attendancecount).to_s + ' slots remain').html_safe
    end
  end

  def get_mealplan_link(event)
    @eventattendance = Eventattendance.find_by(user_id: current_user, event_id: event.id)
    if !event.mealplan?
      return
    elsif @eventattendance.mealplan.in?([nil, ''])
      return link_to 'View Meal Plan', event_mealplan_path(event.id)
    else
      return link_to @eventattendance.mealplan, event_mealplan_path(event.id)
    end

  end

  def get_meal_options(event, eventattendance)
    if eventattendance.registrationtype == 'Cast'
      return [['No Meal', 'No Meal'], ['Meat', 'Meat'], ['Vegan', 'Vegan']]
    elsif eventattendance.mealplan.in?(['Meat', 'Vegan'])
      return [['Meat', 'Meat'], ['Vegan', 'Vegan']]
    elsif eventattendance.mealplan.in?([nil, ''])
      return [['Meat - $' + get_mealplan_cost(event,eventattendance, 'Meat').to_s, 'Meat'], ['Vegan - $' + get_mealplan_cost(event,eventattendance, 'Vegan').to_s, 'Vegan']]
    end
  end

  def get_mealplan_signup(event)
    @eventattendance = Eventattendance.find_by(user_id: current_user, event_id: event.id)
    @selected_meal = @eventattendance.mealplan
    if @selected_meal.in?([nil, '', 'No Meal'])
      @selected_meal = 'None'
    end
    if @selected_meal.in?(['None']) && (event.startdate - early_bird_days > Date.today) && (@eventattendance.registrationtype == 'Player')
      return (render partial: 'event/partials/purchasemealplan')
    elsif (event.startdate - early_bird_days > Date.today) && (@eventattendance.registrationtype == 'Cast')
      return (render partial: 'event/partials/updatemealplan')
    elsif @selected_meal.in?(['Meat', 'Vegan']) && (event.startdate - early_bird_days > Date.today) && (@eventattendance.registrationtype == 'Player')
      return (render partial: 'event/partials/updatemealplan')
    end
  end

  def get_resident_players(event,area)
    cabinlist = +""
    Cabin.all.where(location: area).where.not(name: ['Cast Cabin']).each do |cabin|
      cabinlist.concat('<b>', cabin.name, '</b>')
      cabinlist.concat('<ul>')
        event.eventattendances.where(registrationtype: 'Player', cabin: Cabin.all.find_by(name: cabin.name)).joins(:character).merge(Character.order(name: :asc)).each do |cabinassignment|
          cabinlist.concat('<li>', cabin_resident(cabinassignment))
        end
      cabinlist.concat('</ul>')
    end
    return cabinlist.html_safe
  end

  def get_homeless_players(event)
    cabinlist = +""
    cabinlist.concat('<ul>')
      event.eventattendances.where(registrationtype: 'Player', cabin: nil).includes(:character).references(:character).order("characters.name ASC").each do |cabinassignment|
        cabinlist.concat('<li>', cabin_resident(cabinassignment))
      end
    cabinlist.concat('</ul>')
    return cabinlist.html_safe
  end

  def get_mealplan_cost(event, eventattendance, option)
    if eventattendance.nil?
      return event.mealplancost
    elsif (eventattendance.mealplan.nil? or eventattendance.mealplan.empty?) && (option == 'Meat' or option == 'Vegan')
      return event.mealplancost
    elsif eventattendance.mealplan == 'Brew of the Month Club'
      return event.mealplancost - 5
    end
    return event.mealplancost
  end

  def get_cast_signup(event)
    if !user_signed_in?
      return 'Please create an account before purchasing an event'
    end
    if current_user.usertype == 'Banned'
      return 'An error has occured. Please reach out to support@mythlarp.com'
    end
    @eventattendance = Eventattendance.find_by(user_id: current_user, event_id: event.id)
      if @eventattendance.nil?
        return (render partial: 'event/partials/castsignup')
      else
        return ("<b>You are already registered to play as " + @eventattendance.registrationtype + '</b>').html_safe
      end
  end

  def get_player_signup(event)
    if !user_signed_in?
      return 'Please create an account before purchasing an event'
    end
    if current_user.usertype == 'Banned'
      return 'An error has occured. Please reach out to support@mythlarp.com'
    elsif current_user.usertype == 'Cast' and event.castcount != 0
      return 'Your account is currently set to cast only. Please reach out to support@mythlarp.com'
    end
    @eventattendance = Eventattendance.find_by(user_id: current_user, event_id: event.id)
    if @eventattendance.nil?
      return (render partial: 'event/partials/purchaseevent')
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
    days_till_lockout = (event.startdate - Time.now.in_time_zone('Eastern Time (US & Canada)').to_date).to_i - early_bird_days

    if user_signed_in?
      if (days_till_lockout <= 0)
        return event.atdoorcost
      elsif (Eventattendance.joins(:event).where('user_id = ? and Registrationtype = ? and levelingevent and EventType = ?', current_user.id, 'Player', 'Adventure Weekend').count == 0)
        return event.newplayerprice
      else
        return event.earlybirdcost
      end
    else
      return event.atdoorcost
    end
  end

  def get_event_price_details(event)
    #early_bird_date = event.startdate - 13
    early_bird_date = event.startdate - 11
    days_till_earlybird = (event.startdate - Time.now.in_time_zone('Eastern Time (US & Canada)').to_date).to_i - early_bird_days
    
    event_price_html = ''
    if (days_till_earlybird > 0)
      event_price_html += '<b>New Player Early Bird Rate:</b> $' + event.newplayerprice.to_s + '<br>'
      event_price_html += '<b>Early Bird Pricing:</b> $'+ event.earlybirdcost.to_s + '<br>'
      if days_till_earlybird >= 1
        event_price_html +=  'Early Bird pricing goes till ' + early_bird_date.strftime("%m/%d/%Y") + ' - (Less Than ' + days_till_earlybird.to_s + ' days remain!)<br>'
      else
        hours_till_earlybird = ((DateTime.tomorrow.in_time_zone('Eastern Time (US & Canada)').to_time - Time.now.in_time_zone('Eastern Time (US & Canada)')) / 1.hour).to_i + 1
        event_price_html +=  'Early Bird pricing goes till ' + early_bird_date.strftime("%m/%d/%Y") + ' - (Less Than ' + hours_till_earlybird.to_s + ' hours remain!)<br>'
      end
    end
    event_price_html += '<b>Standard Pricing:</b> $' + event.atdoorcost.to_s + '<br>'
    return event_price_html.html_safe      
  end

  def add_user_to_event(user, event, mealplan, cabin)
    @eventattendance = Eventattendance.new
    @eventattendance.event_id = event.id
    @eventattendance.user_id = user.id
    @eventattendance.registrationtype = 'Player'
    if mealplan == 'None'
      mealplan = nil 
    end
    @eventattendance.mealplan = mealplan
    @eventattendance.cabin_id = cabin
    if (@eventattendance.character_id.nil?) && (@eventattendance.user.characters.where(status: 'Active').count == 1) && (@eventattendance.registrationtype == 'Player') && (event.levelingevent)
      @eventattendance.character_id = @eventattendance.user.characters.find_by(status: 'Active').id
    end

    if @eventattendance.save!
      add_event_exp(event, @eventattendance)
    end
  end

  def get_next_event
    Event.where('enddate > ? AND levelingevent and eventtype = ?', Time.now, 'Adventure Weekend').reorder('startdate ASC').first
  end

  def get_last_event
    Event.where('enddate < ? AND levelingevent and eventtype = ?', Time.now.in_time_zone('Eastern Time (US & Canada)'), 'Adventure Weekend').reorder('enddate desc').first
  end
end
