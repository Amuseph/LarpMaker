# frozen_string_literal: true

class Character < ApplicationRecord
  has_many :characterskills
  has_many :skills, through: :characterskills
  has_many :characterprofessions
  has_many :professions, through: :characterprofessions
  has_many :professiongroups, through: :professions
  has_many :courier
  has_many :banklogs

  belongs_to :user
  has_many :eventattendances
  has_many :events, through: :eventattendances
  belongs_to :race
  belongs_to :characterclass
  belongs_to :deity, optional: true
  belongs_to :house, optional: true
  belongs_to :guild, optional: true
  has_one :backstory

  validates :name, presence: true

  after_update :check_class
  after_create :check_class

  has_one_attached :photo
  validates :photo, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 15.megabytes , message: 'is not given between size' }


  def get_first_name
    
    if self.name.nil?
      return ""
    end
    name_array = self.name.split(" ")
    if name_array[0].length <= 3
      return name_array[0] + " " + name_array[1]
    end
    return name_array[0]
  end

  def check_class
    if characterclass.name != 'Paladin' && characterclass.name != 'Cleric'
      unless self.deity_id == nil
        self.deity_id = nil
        save!
      end
    end

    if characterclass.name != 'Druid'
      unless self.totem == nil
        self.totem = nil
        save!
      end
    end

    if saved_change_to_totem
      if self.totem == ''
        characterskills.each do |charskill|
          charskill.destroy if ['Totemic Gift', 'Totemic Blessing', 'Totemic Protection'].include?(charskill.skill.name )
        end
      end
    end

    if saved_change_to_characterclass_id?
      characterskills.each do |charskill|
        charskill.destroy if charskill.skill.tier >= 4
      end
    end

    if saved_change_to_rewrite?
      if self.rewrite == true
        characterskills.each do |charskill|
          charskill.destroy
        end
      end
    end
  end
end
