# frozen_string_literal: true

class PlayerController < ApplicationController
  include PlayersHelper
  before_action :authenticate_user!

  def changecharacter
    if request.post?
      @changedcharacter = Character.find(changecharacter_params[:character_id])
      current_user.last_character = @changedcharacter.id
      session[:character] = @changedcharacter.id
      current_user.save!

      redirect_to root_path
    else
    end
  end

  def transferxp
    if request.post?
      @transferxp = Explog.create
      transfer_xp(params[:xptransfer][:emailaddress], params[:xptransfer][:amount].to_i)
      redirect_to player_explog_path()
    end

  end

  def validateemail
    user = User.where('lower(email) = ?', params[:email].downcase).first 

    if user.nil?
      response = 'false'
    elsif user.email == current_user.email
      response = 'false'
    else
      response = 'true'
    end
    respond_to do |format|
      format.json { render json: { response: response } }
    end
  end

  def validatexpamount
    xpamount  = params[:xpamount].to_i
    target_user = User.where('lower(email) = ?', params[:email].downcase).first
    max_transfer = 300 - transfer_exp_received(target_user)

    if max_transfer < 0
      max_transfer = 0
    end

    if xpamount <= 0
      response = 'false'
    elsif  (max_transfer < xpamount)
      response = 'User may only have %s more XP transferred for this year' % max_transfer
    elsif  available_xp >= xpamount
      response = 'true'
    else
      response = 'false'
    end
    respond_to do |format|
      format.json { render json: { response: response } }
    end
  end

  private

  def changecharacter_params
    params.require(:changecharacter).permit(:character_id)
  end

  def eventattendance_params
    params.require(:characterattendance).permit(:character_id, :eventattendance_id)
  end
end
