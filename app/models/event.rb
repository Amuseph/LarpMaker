# frozen_string_literal: true

class Event < ApplicationRecord
  has_many :eventattendances
  has_many :characters, through: :eventattendances
  has_many :users, through: :characters

  default_scope { order(startdate: :desc) }

  def self.available_cabins(event, registration)
    available_cabins = []

    if registration.registrationtype = 'Player'
      cabins = Cabin.where(playeravailable: true)
    else
      cabins = Cabin.where(castavailable: true)
    end
    
    cabins.distinct.pluck(:location).each do |cabin_location|
      cabin_list = []
      cabins.where(location: cabin_location).each do |cabin|
        if (event.eventattendances.where(cabin_id: cabin.id).count <= cabin.maxplayers) || cabin.maxplayers = -1
          cabin_list.push([cabin.name, cabin.id])
        end
      end
      unless cabin_list.empty?
        available_cabins.push([cabin_location, cabin_list])
      end
    end
    return available_cabins
  end
  
end
