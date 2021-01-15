class PagesController < ApplicationController
  before_action :check_character_user

  def index

  end

  def check_character_user
    if session[:character]
      if (current_user.id != Character.find(session[:character]).user_id and current_user.usertype != 'Admin')
        session.delete(:character)
      end
    end
  end
end