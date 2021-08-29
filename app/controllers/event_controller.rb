# frozen_string_literal: true

class EventController < ApplicationController
  include EventsHelper
  skip_before_action :verify_authenticity_token

  before_action :paypal_init, :except => [:index, :show, :mealplan]

  def index

  end

  def show
    @event = Event.find(params[:id])
    @myeventattendance = @event.eventattendances.find_by(user_id: current_user.id, event_id: @event.id)
    
  end

  def mealplan
    @event = Event.find(params[:event_id])
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
      @eventfeedback = Eventfeedback.create(feedback_params)
      @eventfeedback.user_id = current_user.id
      @eventfeedback.event_id = params[:event_id]
      @eventfeedback.character_id = @eventattendance.character_id
      if @eventfeedback.save!
        add_feedback_exp(@event, @eventattendance)
      end
    end
  end

  def playersignup
    @event = Event.find(params[:event_id])
    if request.post?
      @eventattendance = Eventattendance.create(event_id: @event.id, user_id: current_user.id, registrationtype: 'Cast')
      if @eventattendance.save!
        add_event_exp(@event, @eventattendance)
      end
    end
  end

  def castsignup
    @event = Event.find(params[:event_id])
    if request.post?
      @eventattendance = Eventattendance.create(event_id: @event.id, user_id: current_user.id, registrationtype: 'Cast')
      if @eventattendance.save!
        add_event_exp(@event, @eventattendance)
      end
    end
  end

  def orderevent
    @event = Event.find(params[:event_id])
    price = get_event_price(@event)
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
            :name => 'Purchased event ' + @event.name,
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
      order.description = 'Purchased event ' + @event.name
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

        add_user_to_event(current_user,@event)

        return render :json => {:status => response.result.status}, :status => :ok
      end
    rescue PayPalHttp::HttpError => ioe

      # HANDLE THE ERROR
    end
  end

  def ordermealplan
    @event = Event.find(params[:event_id])
    price = @event.mealplancost
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
      @availablecabins = Event.available_cabins(@event, @myeventattendance)
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
