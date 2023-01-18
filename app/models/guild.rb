# frozen_string_literal: true

class Guild < ApplicationRecord
  has_many :characters

  belongs_to :guildmaster, class_name: 'Character'

  has_one_attached :photo
  validates :photo, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 15.megabytes , message: 'is not given between size' }
end
