class Characterskill < ApplicationRecord
  belongs_to :skill
  belongs_to :character
  alias_attribute :favoredfoe, :details

end
