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
  after_update :check_noshow

  def check_registration
    if saved_change_to_registrationtype? && registrationtype != 'Player'
      self.character_id = nil
      save!
    end
  end

  def check_noshow
    if saved_change_to_noshow? && registrationtype != 'Player' && noshow
      @explog = Explog.where('acquiredate BETWEEN ? AND ?', event.startdate.beginning_of_day, event.startdate.end_of_day).find_by(
        name: 'Event', user_id: user_id
      )
      @explog&.destroy
    end

    if saved_change_to_noshow? && registrationtype == 'Player' && noshow
      ApplicationController.helpers.add_feedback_exp(event, self)
    end
  end

end
