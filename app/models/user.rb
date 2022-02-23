# frozen_string_literal: true

class User < ApplicationRecord
  has_many :explogs
  has_many :characters
  has_many :eventattendances
  has_many :events, through: :eventattendances
  has_one :explog, foreign_key: 'grantedby_id'

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  validates_presence_of :firstname, :lastname

  validates :zipcode, :format => { :with => %r{\d{5}(-\d{4})?} }, :allow_nil => true

  validates :usertype,
            inclusion: { in: %w[Cast Player Admin Banned],
                         message: '%{value} is not a valid Player Type' }
end
