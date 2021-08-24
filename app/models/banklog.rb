# frozen_string_literal: true

class Banklog < ApplicationRecord
  belongs_to :character

  belongs_to :grantedby, class_name: 'User'

  default_scope { order(acquiredate: :desc) }
end
