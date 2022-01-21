# frozen_string_literal: true

class User < ApplicationRecord
  has_many :explogs
  has_many :characters
  has_many :eventattendances
  has_many :events, through: :eventattendances
  has_one :explog, foreign_key: 'grantedby_id'

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  validates :usertype,
            inclusion: { in: %w[Cast Staff Player Admin],
                         message: '%{value} is not a valid Player Type' }
end
