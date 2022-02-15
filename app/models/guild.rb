# frozen_string_literal: true

class Guild < ApplicationRecord
  has_many :characters

  belongs_to :guildmaster, class_name: 'Character'
end
