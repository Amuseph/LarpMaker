# frozen_string_literal: true

class Characterskill < ApplicationRecord
  belongs_to :skill
  belongs_to :character
  alias_attribute :favoredfoe, :details
  alias_attribute :chosenelement, :details
end
