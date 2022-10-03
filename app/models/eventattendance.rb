# frozen_string_literal: true

class Eventattendance < ApplicationRecord
  belongs_to :event
  belongs_to :user
  belongs_to :character, optional: true
  belongs_to :cabin, optional: true

  validates :user, presence: true
  validates :event, presence: true
  validates :registrationtype, presence: true
  validates :event, uniqueness: { scope: :user }

  after_update :check_registration

  def check_registration
    if saved_change_to_registrationtype? && registrationtype != 'Player'
      self.character_id = nil
      save!
    end
  end

end
