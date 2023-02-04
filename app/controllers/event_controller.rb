# frozen_string_literal: true

class EventController < ApplicationController
  include EventsHelper
  skip_before_action :verify_authenticity_token

  before_action :paypal_init, :except => [:index, :show, :mealplan]
  before_action :authenticate_user!, except: [:playersignup, :castsignup]

  def index

  end

  def playerlist
    @event = Event.find(params[:event_id])
  end

  def show
    @event = Event.find(params[:id])
    @myeventattendance = @event.eventattendances.find_by(user_id: current_user.id, event_id: @event.id)
  end

  def mealplan
    @event = Event.find(params[:event_id])
    myeventattendance = Eventattendance.find_by(event_id: params[:event_id], user_id: current_user.id)
    @mealoptions = get_meal_options(@event, myeventattendance)
  end

  def viewfeedback
    @event = Event.find(params[:event_id])
    @ratingoptions = [['Very Satisfied', 1], ['Somewhat Satisfied', 2], ['Neither Satisfied or Dissatisfied', 3], ['Somewhat Dissatisfied', 3], ['Very Dissatisfied', 5]]
    @eventfeedback = Eventfeedback.find_by('event_id = ? and user_id = ?', params[:event_id], current_user.id)
  end

  def submitfeedback
    @event = Event.find(params[:event_id])
    @ratingoptions = [['Very Satisfied', 1], ['Somewhat Satisfied', 2], ['Neither Satisfied or Dissatisfied', 3], ['Somewhat Dissatisfied', 3], ['Very Dissatisfied', 5]]
    @eventattendance = @event.eventattendances.find_by(user_id: current_user.id, event_id: @event.id)
    if request.post?
      if Eventfeedback.find_by(event_id: params[:event_id], user_id: current_user.id).nil?
        @eventfeedback = Eventfeedback.create(feedback_params)
        @eventfeedback.user_id = current_user.id
        @eventfeedback.event_id = params[:event_id]
        @eventfeedback.character_id = @eventattendance.character_id
        if @eventfeedback.save!
          add_feedback_exp(@event, @eventattendance)
          EventMailer.with(eventfeedback: @eventfeedback).send_event_feedback.deliver_later
          
        end
      end
      redirect_to event_viewfeedback_path(params[:event_id])
    end
  end

  def playersignup
    @event = Event.find(params[:event_id])
    if user_signed_in?
      if (@event.mealplan && @event.mealplancost == 0)
        @mealoptions = [['Meat - $' + get_mealplan_cost(@event,nil, 'Meat').to_s, 'Meat'], ['Vegan - $' + get_mealplan_cost(@event,nil, 'Vegan').to_s, 'Vegan']]
      elsif @event.mealplan
        @mealoptions = [['None', 'None'], ['Brew of the Month Club - $5', 'Brew of the Month Club'], ['Meat - $' + get_mealplan_cost(@event,nil, 'Meat').to_s, 'Meat'], ['Vegan - $' + get_mealplan_cost(@event,nil, 'Vegan').to_s, 'Vegan']]
      else
        @mealoptions = [['None', 'None']]
      end
    end
  end

  def castsignup
    @event = Event.find(params[:event_id])
    if request.post?
      @eventattendance = Eventattendance.create(event_id: @event.id, user_id: current_user.id, registrationtype: 'Cast')
      @eventattendance.mealplan = params[:mealplan][:mealchoice]
      if @eventattendance.save!
        add_event_exp(@event, @eventattendance)
        redirect_to event_index_path
      end
    end
  end

  def orderevent
    if !Eventattendance.find_by(event_id: params[:event_id], user_id: current_user.id).nil?
      redirect_to event_index_path
    end
    @event = Event.find(params[:event_id])
    @cabin = Cabin.find(params[:eventpurchase][:cabin])
    @mealchoice = params[:eventpurchase][:mealchoice]

    @eventprice = get_event_price(@event)

    if @mealchoice != 'None'
      return @eventprice = @eventprice + get_mealplan_cost(@event,@myeventattendance, @mealchoice)
    end
  end

  def prepareeventorder
    if !Eventattendance.find_by(event_id: params[:event_id], user_id: current_user.id).nil?
      return redirect_to event_index_path
    end
    @event = Event.find(params[:event_id])
    
    mealchoice = params[:meal_type]
    totalprice = get_event_price(@event)
    if mealchoice != 'None'
      totalprice = totalprice + get_mealplan_cost(@event,@myeventattendance, mealchoice)
    end
    request = PayPalCheckoutSdk::Orders::OrdersCreateRequest::new
    
    if mealchoice != 'None'
      request.request_body({
        :intent => 'CAPTURE',
        :purchase_units => [
          {
            :amount => {
              :currency_code => 'USD',
              :value => totalprice,
              :breakdown => {
                :item_total => {
                  :value => totalprice, 
                  :currency_code => 'USD'}
              }
            },
            :items => [{
              :name => 'Purchased event ' + @event.name,
              :quantity => '1',
              :unit_amount => {
                  :currency_code => 'USD',
                  :value => get_event_price(@event)
              }
            },{
              :name => 'Purchased meal plan ' + mealchoice,
              :quantity => '1',
              :unit_amount => {
                  :currency_code => 'USD',
                  :value => get_mealplan_cost(@event,@myeventattendance, mealchoice)
              }
            }]
          }
        ]
      })
    else
      request.request_body({
        :intent => 'CAPTURE',
        :purchase_units => [
          {
            :amount => {
              :currency_code => 'USD',
              :value => totalprice,
              :breakdown => {
                :item_total => {
                  :value => totalprice, 
                  :currency_code => 'USD'}
              }
            },
            :items => [{
              :name => 'Purchased event ' + @event.name,
              :quantity => '1',
              :unit_amount => {
                  :currency_code => 'USD',
                  :value => get_event_price(@event)
              }
            }]
          }
        ]
      })
    end
    
    
    begin
      response = @client.execute request
      order = Order.new
      order.user_id = current_user.id
      order.amount = totalprice.to_i
      order.description = 'Purchased event ' + @event.name + ' with mealplan: ' + mealchoice
      order.status = response.result.status
      order.token = response.result.id
      if order.save
        return render :json => {:token => response.result.id}, :status => :ok
      end
    rescue PayPalHttp::HttpError => ioe
      # HANDLE THE ERROR
    end
    
  end

  def processeventorder
    @event = Event.find_by(id: params[:event_id])
    request = PayPalCheckoutSdk::Orders::OrdersCaptureRequest::new params[:order_id]

    begin
      response = @client.execute request
      order = Order.find_by(token: response.result.id)
      order.status = response.result.status
      order.save!
      if response.result.status == 'COMPLETED'

        add_user_to_event(current_user, @event, params[:meal_type], params[:cabin])

        return render :json => {:status => response.result.status}, :status => :ok
      end
    rescue PayPalHttp::HttpError => ioe

      # HANDLE THE ERROR
    end
  end

  def updatemealplan
    @event = Event.find_by(id: params[:event_id])
    @eventattendance = Eventattendance.find_by(event_id: params[:event_id], user_id: current_user.id)
    @eventattendance.mealplan = params[:mealplan][:mealchoice]
    if @eventattendance.save
      redirect_to event_path(params[:event_id])

    end
  end

  def ordermealplan
    if !Eventattendance.find_by(event_id: params[:event_id], user_id: current_user.id, mealplan: params[:mealplan][:mealchoice]).nil?
      return redirect_to event_index_path
    end
    @event = Event.find_by(id: params[:event_id])
    @myeventattendance = Eventattendance.find_by(event_id: params[:event_id], user_id: current_user.id)
    @mealchoice = params[:mealplan][:mealchoice]
    @mealcost = get_mealplan_cost(@event,@myeventattendance, @mealchoice)
  end

  def preparemealplanorder
    if !Eventattendance.find_by(event_id: params[:event_id], user_id: current_user.id, mealplan: params[:meal_type]).nil?
      return redirect_to event_index_path
    end
    @event = Event.find(params[:event_id])
    @myeventattendance = Eventattendance.find_by(event_id: params[:event_id], user_id: current_user.id)
    price = get_mealplan_cost(@event,@myeventattendance, params[:meal_type])
    request = PayPalCheckoutSdk::Orders::OrdersCreateRequest::new
    request.request_body({
      :intent => 'CAPTURE',
      :purchase_units => [
        {
          :amount => {
            :currency_code => 'USD',
            :value => price,
            :breakdown => {
              :item_total => {
                :value => price, 
                :currency_code => 'USD'}
            }
          },
          :items => [{
            :name => params[:meal_type] + ' Meal Plan for ' + @event.name,
            :quantity => '1',
            :unit_amount => {
                :currency_code => 'USD',
                :value => price
            }
          }]
        }
      ]
    })
    begin
      response = @client.execute request
      order = Order.new
      order.user_id = current_user.id
      order.amount = price.to_i
      order.description = 'Purchased ' + params[:meal_type] + ' meal plan for ' + @event.name
      order.status = response.result.status
      order.token = response.result.id
      if order.save
        return render :json => {:token => response.result.id}, :status => :ok
      end
    rescue PayPalHttp::HttpError => ioe
      # HANDLE THE ERROR
    end
  end

  def processmealplanorder
    @myeventattendance = Eventattendance.find_by(event_id: params[:event_id], user_id: current_user.id)
    request = PayPalCheckoutSdk::Orders::OrdersCaptureRequest::new params[:order_id]
    begin
      response = @client.execute request
      order = Order.find_by(token: response.result.id)
      order.status = response.result.status
      order.save!
      if response.result.status == 'COMPLETED'
        @myeventattendance.mealplan = params[:meal_type]
        @myeventattendance.save
        return render :json => {:status => response.result.status}, :status => :ok
      end
    rescue PayPalHttp::HttpError => ioe
      # HANDLE THE ERROR
    end
  end

  def updatecabin
    @myeventattendance = Eventattendance.find_by(event_id: params[:event_id], user_id: current_user.id)
    if request.patch?
      @myeventattendance.update(eventattendance_params)
      redirect_to event_path(params[:event_id])
    else
      @event = Event.find(params[:event_id])
      @availablecabins = Event.available_player_cabins(@event)
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def eventattendance_params
    params.require(:eventattendance).permit(:event_id, :cabin_id)
  end

  def feedback_params
    params.require(:eventfeedback).permit(:preeventcommunicationrating, :eventrating, :attendnextevent, :sleepingrating, :openingmeetingrating, :closingmeetingrating, :plotrating, :feedback, :questions, :standoutplayers, :standoutnpc, :eventrating, :nexteventplans, :charactergoals, :charactergoalactions, :whatdidyoudo, :professions)
  end

  def paypal_init
    paypal_client_id = ENV['PAYPAL_CLIENT_ID']
    paypal_client_secret = ENV['PAYPAL_CLIENT_SECRET']
    if ENV['PAYPAL_ENV'] == 'live'
      environment = PayPal::LiveEnvironment.new paypal_client_id, paypal_client_secret
    else
      environment = PayPal::SandboxEnvironment.new paypal_client_id, paypal_client_secret
    end
    @client = PayPal::PayPalHttpClient.new environment
  end
end
