# frozen_string_literal: true

class Eventfeedback < ApplicationRecord
  belongs_to :event
  belongs_to :user
  belongs_to :character, optional: true
end
