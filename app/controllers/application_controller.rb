# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :check_character_session

  def index
  end

  protected

  def check_character_session
    if !user_signed_in?
      session.delete(:character)
    elsif session[:character].nil? && !current_user.last_character.nil?
      session[:character] = current_user.last_character
    elsif session[:character].nil? && !current_user.characters.first.nil?
      session[:character] = current_user.characters.first.id
      current_user.last_character = session[:character]
      current_user.save!
    end

    if session[:character] && Character.find(session[:character]).nil?
      session.delete(:character)
    elsif session[:character] && ((current_user.id != Character.find(session[:character]).user_id) && (current_user.usertype != 'Admin'))
      session.delete(:character)
    end

    @character = Character.find_by(id: session[:character])
  end
end
