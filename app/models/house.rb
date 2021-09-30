# frozen_string_literal: true

class House < ApplicationRecord
  has_many :characters

  belongs_to :thane, class_name: 'Character'

end
