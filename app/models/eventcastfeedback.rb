# frozen_string_literal: true

class Eventcastfeedback < ApplicationRecord
  belongs_to :event
  belongs_to :user
end
