# frozen_string_literal: true

class Incident < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :reportedby, class_name: 'User', optional: true

end
