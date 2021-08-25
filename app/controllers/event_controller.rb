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

  def castsignup
    @event = Event.find(params[:event_id])
    if request.post?
      @eventattendance = Eventattendance.create(event_id: @event.id, user_id: current_user.id, registrationtype: 'Cast')
      if @eventattendance.save!
        helpers.add_event_xp(@event, @eventattendance)
      end
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
