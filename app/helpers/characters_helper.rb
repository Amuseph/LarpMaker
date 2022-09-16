# frozen_string_literal: true

module CharactersHelper
  def can_edit_character()
    if !sheetsLocked 
      if Setting.allow_global_reroll
        true
      elsif (@character.events.where('startdate <= ? AND levelingevent = ? ', Time.now, true).count) < 1
        true
      end
    end
  end

  def can_rewrite_character()
    if !sheetsLocked 
      if Setting.allow_global_reroll
        false
      elsif (@character.rewrite)
        false
      elsif (@character.events.where('startdate <= ? AND levelingevent = ? ', Time.now, true).count) < 1
        false
      elsif (@character.events.where('startdate <= ? AND levelingevent = ? ', Time.now, true).count) < 4
        true
      end
    end
  end

  def canLevel(character)
    unless sheetsLocked || character.level >= 20
      last_played_event = last_played_event(character)
      events_played = character.events.where('startdate < ? and levelingevent = ?', Time.now, true).count
      if character.user.explogs.where('acquiredate <= ? ', Time.now).sum(:amount) >= expToLevel(character)
        if last_played_event > character.levelupdate
          true
        elsif !Setting.one_level_per_game && (events_played >= character.level)
          true
        end
      end
    end
  end

  def professions_to_buy(character)
    @freeprofessions = false
    availableexp = current_user.explogs.where('acquiredate <= ? ', Time.now.in_time_zone('Eastern Time (US & Canada)').end_of_day).sum(:amount)

    availableprofessions = []
    availablegroups = []

    Professiongroup.where('playeravailable = true').each do |professiongroup|
      professionlist = []
      professiongroup.professions.where('playeravailable = true').each do |profession|
        @freeprofessions = true if character.professions.where("name like 'Novice%'").count < 2
        next if @freeprofessions && !profession.name.start_with?('Novice')

        if Professionrequirement.exists?(profession: profession.id)
          canpurchase = true
          Professionrequirement.where(profession: profession.id).each do |r|
            canpurchase = false unless character.professions.exists?(id: r.requiredprofession_id)
          end
          next unless canpurchase
        end
        next if character.professions.where(name: profession.name).count >= 1
        next if (availableexp < profession_exp_cost(profession)) && !@freeprofessions

        professionlist.push([profession.name, profession.id])
      end
      unless professionlist.empty?
        availableprofessions.push([professiongroup.name, professionlist])
        availablegroups.push(professiongroup.name)
      end
    end
    return availableprofessions, availablegroups

  end

  def canBuyProfession(character)
    availableprofessions, availablegroups = professions_to_buy(character)

    if !sheetsLocked
      last_played_event = last_played_event(character)
      events_played = character.events.where('startdate < ? and levelingevent = ?', Time.now, true).count
      max_profession_date = character.characterprofessions.maximum('acquiredate')
      max_profession_date = '1900-01-01'.to_date if max_profession_date.nil?

      if character.characterprofessions.count < 2 && last_played_event < character.createdate
        # Buy 2 professions your first game
        true
      elsif availableprofessions.empty?
        return false
      elsif character.characterprofessions.where('acquiredate > ?', last_played_event).count < profsPerEvent(character)
        true
      elsif !Setting.one_level_per_game && ((events_played * profsPerEvent(character)) + 2 > character.characterprofessions.count)
        true
      end
    end
  end

  def can_refund_skill(characterskill)
    last_played_event = last_played_event(@character)
    events_played = @character.events.where('startdate < ?', Time.now).count
    if sheetsLocked
      return false
    end
    characterskill.skill.skillrequirements.each do |skillreq|
      if @character.skills.exists?(id: skillreq.skill_id) && (@character.skills.where('skill_id = ?', skillreq.requiredskill_id).count < 2)
        # Required as part of another skill. Don't delete if you only own 1.
        return false
      end
    end

    if (characterskill.skill.tier == 4) && (@character.skills.where('tier = 4').count <= 2) && (@character.skills.where('tier = 5').count >= 1)
      # Required as part of Tier 5 pyramid
      return false
    elsif (characterskill.skill.tier == 4) && (@character.skills.where('tier = 4').count <= 3) && (@character.skills.where('tier = 6').count >= 1)
      # Required as part of Tier 6 pyramid
      return false
    elsif (characterskill.skill.tier == 5) && (@character.skills.where('tier = 5').count <= 2) && (@character.skills.where('tier = 6').count >= 1)
      # Required as part of Tier 6 pyramid
      return false
    elsif (Setting.allow_global_reroll)
      # Allowing everyone to reroll
      return true
    elsif last_played_event < characterskill.acquiredate
      # Skill has never been used
      return true
    elsif characterskill.skill.tier.zero?
      # Skill has been used and is tier 0
      return false
    elsif @character.user.explogs.where('acquiredate <= ? ', Time.now).sum(:amount) > skill_refund_price(characterskill)
      # Player can afford skill
      return true
    end
  end

  def edit_backstory_link
    if @character.backstory.nil?
      link_to 'Add A Backstory - ', character_editbackstory_path
    elsif !@character.backstory.locked
      link_to 'Edit Your Backstory - ', character_editbackstory_path
    end
  end

  def backstory_status
    if @character.backstory.nil?
      return 'Backstory Pending Submission <br>'.html_safe
    else
      if !@character.backstory.locked?
        return 'Backstory Pending Submission <br>'.html_safe
      elsif @character.backstory.locked? && !@character.backstory.approved?
        return 'Backstory Pending Approval <br>'.html_safe
      end
    end
  end

  def display_backstory
    if !@character.backstory.nil?
      return simple_format @character.backstory.backstory
    end
  end

  def canRefundProfession(character, characterprofession)
    last_played_event = last_played_event(character)
    events_played = character.events.where('startdate < ?', Time.now).count
    starter_professions = character.characterprofessions.order('characterprofessions.acquiredate asc').first(2)

    if sheetsLocked
      return false
    end
    characterprofession.profession.professionrequirements.each do |profreq|
      if character.professions.exists?(id: profreq.profession_id)
        # Required as part of another profession.
        return false
      end
    end

    if (Setting.allow_global_reroll)
      # Allowing everyone to reroll
      true
    elsif last_played_event < characterprofession.acquiredate
      # Profession has never been used
      return true
    end
  end

  def skill_refund_price(characterskill)
    last_played_event = last_played_event(@character)
    if (Setting.allow_global_reroll)
      # Allowing everyone to reroll
      0
    elsif last_played_event < characterskill.acquiredate
      # Skill has never been used
      0
    elsif Setting.allow_global_reroll
      # Skill has never been used
      0
    else
      characterskill.skill.tier * 25
    end
  end

  def last_played_event(character)
    if character.events.where('startdate < ? AND levelingevent', Time.now).maximum(:startdate).nil?
      return '1900-01-01'.to_date
    end

    character.events.where('startdate < ?', Time.now).maximum(:startdate).to_date
  end

  def oracles_available()
    purchasedOracles = @character.skills.where(name: 'Oracle').count 
    usedOracles = @character.courier.where('senddate > ? and couriertype = ?', last_played_event(@character), 'Oracle').sum(:skillsused)
    return purchasedOracles - usedOracles
  end

  def ravens_available(character)
    if ((character.characterclass.name == 'Druid') && (character.totem == 'Raven') && (@character.skills.where(name: 'Totemic Blessing').count >= 1) && (character.courier.where('senddate > ? and couriertype = ?', last_played_event(@character), 'Raven').sum(:skillsused) < 1))
      return 1
    else
      return 0
    end
  end

  def expToLevel(character)
    if character.level.between?(0, 1)
      400
    elsif character.level.between?(2, 9)
      500
    elsif character.level.between?(10, 12)
      600
    elsif character.level.between?(13, 14)
      700
    elsif character.level.between?(15, 16)
      800
    elsif character.level.between?(17, 18)
      900
    elsif character.level.between?(19, 20)
      1000
    end
  end

  def profsPerEvent(character)
    if character.skills.exists?(name: "Artisan's Devotion")
      2
    elsif character.skills.exists?(name: 'Channel Divinity') && (character.deity.name == 'Ixbus')
      2
    else
      1
    end
  end

  def percentToLevel(character)
    totalXP = character.user.explogs.where('acquiredate <= ? ', Time.now).sum(:amount).to_f.to_f
    totalXP / expToLevel(character).to_f * 100.0
  end

  def percentOfCP(_character)
    totalCP = ((@character.level * 50) + 50).to_f
    currentCP = ((@character.skills.sum(:tier) * 10)).to_f

    currentCP / totalCP * 100.0
  end

  def get_house_details()
    if @character.house.nil?
      return 'Join a house in-game! See the rulebook for more details.'
    else
      return render 'character/housedetails'
    end
  end

  def get_guild_details()
    if @character.guild.nil?
      return 'Join a guild in-game! See the rulebook for more details.'
    else
      return render 'character/guilddetails'
    end
  end

  def get_house_members(house)
    memberlist = +""
    house.characters.each do |member|
      memberlist.concat(member.get_name, '<br>')
    end
    return memberlist.html_safe
  end

  def get_guild_members(guild)
    memberlist = +""
    guild.characters.each do |member|
      memberlist.concat(member.get_name, '<br>')
    end
    return memberlist.html_safe
  end

  def profession_exp_cost(profession)
    if profession.name.start_with?('Novice')
      100
    elsif profession.name.start_with?('Journeyman')
      200
    elsif profession.name.start_with?('Master')
      300
    end
  end

  def has_skill_prereq(_character, skill)
    if Skillrequirement.exists?(skill: skill.id)
      Skillrequirement.where(skill: skill.id).each do |r|
        if !@character.skills.exists?(id: r.requiredskill_id)
          return false
        end
      end
    end
    return true
  end
  def can_purchase_skill(_character, skill)
    if ! has_skill_prereq(@character, skill)
      return false
    end
    if @character.skills.where(name: skill.name).count >= skill.maxpurchase
      return false
    elsif skill.tier > (((@character.level * 50) + 50) - (@character.skills.sum(:tier) * 10)) / 10
      return false
    elsif (skill.tier == 5) && (@character.skills.where('tier = 4').count < 2)
      return false
    elsif (skill.tier == 6) && ((@character.skills.where('tier = 4').count < 3) || (@character.skills.where('tier = 5').count < 2))
      return false
    end

    true
  end
end