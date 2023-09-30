# frozen_string_literal: true

class Event < ApplicationRecord
  has_many :eventattendances
  has_many :eventfeedbacks
  has_many :eventcastfeedbacks
  has_many :characters, through: :eventattendances
  has_many :users, through: :characters

  has_one_attached :context
  validates :context, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 15.megabytes , message: 'is not given between size' }

  default_scope { order(startdate: :desc) }

  def self.available_cabins(event)
    available_cabins = []

    cabins = Cabin.all
    
    cabins.distinct.pluck(:location).each do |cabin_location|
      cabin_list = []
      cabins.where(location: cabin_location).each do |cabin|
        if (event.eventattendances.where(cabin_id: cabin.id).count < cabin.maxplayers) || cabin.maxplayers == -1
          cabin_list.push([cabin.name, cabin.id])
        end
      end
      unless cabin_list.empty?
        available_cabins.push([cabin_location, cabin_list])
      end
    end
    return available_cabins
  end

  def self.available_player_cabins(event)
    available_cabins = []

    cabins = Cabin.where(playeravailable: true)
    
    cabins.distinct.pluck(:location).each do |cabin_location|
      cabin_list = []
      cabins.where(location: cabin_location).each do |cabin|
        if (event.eventattendances.where(cabin_id: cabin.id).count < cabin.maxplayers) || cabin.maxplayers == -1
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
