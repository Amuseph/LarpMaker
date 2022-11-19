# frozen_string_literal: true

class CharacterController < ApplicationController
  include CharactersHelper
  include PlayersHelper
  include PagesHelper
  before_action :authenticate_user!
  before_action :check_character_user
  before_action :check_sheets_locked, only: %i[edit update trainskill trainprofession]
  layout 'print_view', only: [:printablesheet]

  def index
    
  end

  def new
    @character = Character.new
    @race = Race.all.where('playeravailable = true')
    @characterclass = Characterclass.all.where('playeravailable = true')
    @deity = Deity.all.where('playeravailable = true')
  end

  def create
    @character = Character.new(character_params)
    @character.user_id = current_user.id

    if @character.save!
      current_user.last_character = @character.id
      session[:character] = @character.id
      current_user.save!
      redirect_to character_index_path
    end
  end

  def edit
    @race = Race.all.where('playeravailable = true')
    @characterclass = Characterclass.all.where('playeravailable = true')
    @deity = Deity.all.where('playeravailable = true')
  end

  def rewrite
    @race = Race.all.where('playeravailable = true')
    @characterclass = Characterclass.all.where('playeravailable = true')
    @deity = Deity.all.where('playeravailable = true')

    if !can_rewrite_character()
      redirect_to root_path
    end
  end

  def update
    @character = Character.find(session[:character])
    @oldname = @character.name
    @character.update(character_params)

    Explog.where("user_id = ? AND name = ? and description like ?", @character.user_id, 'Profession Purchase', "Purchased % for \"#{@oldname}\"" ).each do |explog|
      explog.description = explog.description.sub(@oldname, @character.name)
      explog.save!
    end

    if params[:id] == 'rewrite'
      if can_rewrite_character()
        @character.rewrite = true
        @character.save!
      end
    end

    redirect_to root_path
  end

  def viewcourier
    @courier = Courier.find(params[:courier_id])
    respond_to do |format|
      format.js
    end
  end

  def sendcourier
    if request.post?
      @courier = Courier.new(sendcourier_params)
      @courier.character_id = session[:character]
      @courier.couriertype = 'Courier'
      @courier.skillsused = 0
      if @courier.save
        CharacterMailer.with(courier: @courier).send_courier.deliver_later
      end
      redirect_to character_courier_path
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def sendprayer
    if request.post?
      @courier = Courier.new(sendcourier_params)
      @courier.couriertype = 'Prayer'
      @courier.destination = 'Self'
      @courier.skillsused = 0
      @courier.character_id = session[:character]
      if @courier.save
        CharacterMailer.with(courier: @courier).send_prayer.deliver_later
      end
      redirect_to character_courier_path
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def sendoracle
    @oraclecount =  oracles_available()
    if request.post?
      @courier = Courier.new(sendcourier_params)
      @courier.couriertype = 'Oracle'
      @courier.recipient = @character.deity.name
      @courier.destination = 'Self'
      @courier.character_id = session[:character]
      if @courier.save
        CharacterMailer.with(courier: @courier).send_oracle.deliver_later
      end
      redirect_to character_courier_path
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def sendraven
    if request.post?
      @courier = Courier.new(sendcourier_params)
      @courier.couriertype = 'Raven'
      @courier.destination = 'Self'
      @courier.recipient = 'Raven'
      @courier.skillsused = 1
      @courier.character_id = session[:character]
      if @courier.save
        CharacterMailer.with(courier: @courier).send_prayer.deliver_later
      end
      redirect_to character_courier_path
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def levelup
    @exptolevel = expToLevel(@character)

    if canLevel(@character)
      @character.level = @character.level + 1
      @character.levelupdate = Time.now

      @explog = Explog.new
      @explog.user_id = @character.user_id
      @explog.name = 'Level Up'
      @explog.acquiredate = Time.now
      @explog.description = "Leveled \"#{@character.name}\" to #{@character.level}"
      @explog.amount = @exptolevel * -1
      @explog.grantedby_id = current_user.id

      @explog.save!
      @character.save!
    end
    redirect_to character_index_path
  end

  def changephoto
    @character = Character.find(session[:character])
    if request.post?
      @character.photo.attach(params[:characterphoto])
      redirect_to character_index_path()
    else

      respond_to do |format|
        format.js
      end
    end
  end

  def getcharacter
    @character = Character.find(params[:character_id])
    @deity = @character.deity
    @characterclass = @character.characterclass

    respond_to do |format|
      format.json do
        render json: { all_data: { character: @character, deity: @deity, characterclass: @characterclass } }
      end
    end
  end

  def trainskill
    if request.post?
      @characterskill = Characterskill.new(addskill_params)
      
      @characterskill.character_id = session[:character]
      @characterskill.save! if can_purchase_skill(@character, @characterskill.skill)
      redirect_to character_index_path({ tab: 'skills' })

    else
      @characterskill = Characterskill.new

      
      @favoredfoes = ['Beasts', 'Constructs', 'Elementals', 'Monstrous Humanoids', 'Plants',
                      'Undead'] - @character.characterskills.where(skill: Skill.where(name: 'Favored Foe')).pluck('details')
      @availableskills = []
      @availablegroups = []

      @character.characterclass.skillgroups.where('skillgroups.playeravailable = true').each do |skillgroup|
        skilllist = []
        if (skillgroup.name == 'Druid' && @character.totem == '')
          totemskills = ['Totemic Gift', 'Totemic Blessing', 'Totemic Protection']
          skills = @character.characterclass.skills.where('skills.playeravailable = true and skills.skillgroup_id = ? and skills.name NOT IN (?)', skillgroup.id, totemskills)
        else
          skills = @character.characterclass.skills.where('skills.playeravailable = true and skills.skillgroup_id = ?', skillgroup.id)
        end
        skills.each do |skill|
          skilllist.push([skill.name, skill.id]) if can_purchase_skill(@character, skill)
        end
        unless skilllist.empty?
          @availableskills.push([skillgroup.name, skilllist])
          @availablegroups.push(skillgroup.name)
        end
      end
      respond_to do |format|
        format.js
      end
    end
  end

  def removeskill
    @characterskill = Characterskill.order('acquiredate desc, id desc').find_by(skill_id: params[:skill_id],
                                                                                character_id: session[:character])

    if skill_refund_price(@characterskill) < 1
      @characterskill.destroy
    else
      @explog = Explog.new
      @explog.user_id = @character.user_id
      @explog.name = 'Skill Refund'
      @explog.acquiredate = Time.now
      @explog.description = "Refunded \"#{@characterskill.skill.name}\" for \"#{@character.name}\""
      @explog.amount = skill_refund_price(@characterskill) * -1
      @explog.grantedby_id = current_user.id
      @explog.save!
      @characterskill.destroy
    end
    redirect_to character_index_path({ tab: 'skills' })
  end

  def learnprofession
    if request.post?
      if can_buy_profession(@character)
        @characterprofession = Characterprofession.new(addprof_params)
        @characterprofession.character_id = session[:character]
        if @characterprofession.save!
          if (@character.characterprofessions.count > 2) || (get_last_played_event(@characterprofession.character) > @characterprofession.character.createdate)
            @explog = Explog.new
            @explog.user_id = @character.user_id
            @explog.name = 'Profession Purchase'
            @explog.acquiredate = @characterprofession.acquiredate
            @explog.description = "Purchased \"#{@characterprofession.profession.name}\" for \"#{@character.name}\""
            @explog.amount = profession_exp_cost(@characterprofession.profession) * -1
            @explog.grantedby_id = current_user.id
            @explog.save!
          end
        end
      end
      redirect_to character_index_path({ tab: 'professions' })

    else
      @availableprofessions,  @availablegroups = professions_to_buy(@character)
      respond_to do |format|
        format.js
      end
    end
  end

  def editbackstory
    @backstory = @character.backstory
  end

  def savebackstory
    if @character.backstory.nil?
      @backstory = Backstory.new(backstory_params)
      @backstory.character_id = session[:character]
    else
      @backstory = @character.backstory
      @backstory.update(backstory_params)
    end

    if params[:commit] == 'Save Backstory'
      if @backstory.save
        redirect_to character_index_path
      end
    elsif params[:commit] == 'Submit Backstory'
      @backstory.locked = true
      if @backstory.save
        CharacterMailer.with(backstory: @backstory).send_backstory.deliver_later
        redirect_to character_index_path
      end
    end
  end

  def removeprofession
    @characterprofession = Characterprofession.order('acquiredate desc, id desc').find_by(
      profession_id: params[:profession_id], character_id: session[:character]
    )

    @explog = Explog.find_by(
      user_id: @character.user_id,
      name: 'Profession Purchase',
      description: "Purchased \"#{@characterprofession.profession.name}\" for \"#{@character.name}\"",
      amount: profession_exp_cost(@characterprofession.profession) * -1
    )
    @explog&.destroy
    @characterprofession.destroy
    redirect_to character_index_path({ tab: 'professions' })
  end

  def spendxp
    item_sold = params[:item]
    last_played_event = get_last_played_adventure(@character)
    profession_count = current_user.explogs.where('name = ? and acquiredate >= ? and (description LIKE ? OR description LIKE ? OR description LIKE ?)', 'XP Store', last_played_event.enddate, 'Collecting%', 'Refining%', 'Crafting%').count
    secondwind_count = current_user.explogs.where('name = ? and acquiredate >= ? and description = ?', 'XP Store', last_played_event.enddate, 'Second Wind').count
    lucktoken_count = current_user.explogs.where('name = ? and acquiredate >= ? and description = ?', 'XP Store', last_played_event.enddate, 'Luck Token').count

    case item_sold
      when 'GoodFortune'
        item_sold = 'Good Fortune'
        item_cost = 250
      when 'GravenMiracle'
        item_sold = 'Graven Miracle'
        item_cost = gravencost()
      when 'BodyPanacea'
        item_sold = 'Body Panacea'
        item_cost = 150
      when 'SpiritPanacea'
        item_sold = 'Spirit Panacea'
        item_cost = 150
      when 'MindPanacea'
        item_sold = 'Mind Panacea'
        item_cost = 150
      when 'Collecting', 'Refining', 'Crafting'
        profession = Profession.find(params[:itempurchase])
        item_sold = item_sold + ' - ' + profession.name
        item_cost = 50
      when 'SecondWind'
        item_sold = 'Second Wind'
        item_cost = 100
      when 'LuckToken'
        item_sold = 'Luck Token'
        item_cost = 250
      when 'Tier1'
        item_cost = 25
        skill = Skill.find(params[:skillpurchase])
        item_sold = item_sold + ' - ' + skill.name
      when 'Tier2'
        item_cost = 35
        skill = Skill.find(params[:skillpurchase])
        item_sold = item_sold + ' - ' + skill.name
      when 'Tier3'
        item_cost = 50
        skill = Skill.find(params[:skillpurchase])
        item_sold = item_sold + ' - ' + skill.name
      when 'Juniper'
        item_cost = 50
        item_sold = 'Juniper'
      when 'WeepingWillow'
        item_cost = 100
        item_sold = 'Weeping Willow - Left'
    end

    if item_cost > available_xp
      redirect_to player_explog_path
    elsif spent_xpstore_xp + item_cost > 500 && params[:item] != 'GravenMiracle'
      redirect_to player_explog_path
    elsif ['Collecting', 'Refining', 'Crafting'].include? params[:item] and profession_count >= 1
      redirect_to player_explog_path
    elsif secondwind_count >= 1 and params[:item] == 'SecondWind' 
      redirect_to player_explog_path
    elsif lucktoken_count >= 1 and params[:item] == 'LuckToken' 
      redirect_to player_explog_path
    else
      @explog = Explog.new
      @explog.user_id = @character.user_id
      @explog.name = 'XP Store'
      @explog.acquiredate = Time.now
      @explog.description = item_sold
      @explog.amount = item_cost * -1
      @explog.grantedby_id = current_user.id
      @explog.save!
      if (item_sold == 'Juniper' or item_sold == 'Weeping Willow - Left')
        eventattendance = Eventattendance.find_by(id: params[:cabinpurchase])
        eventattendance.cabin = Cabin.find_by(name: item_sold)
        eventattendance.save!
      end
      redirect_to player_explog_path
    end
  end

  private

  def character_params
    params.require(:character).permit(:name, :pronouns, :deity_id, :race_id, :characterclass_id, :totem, :alias, :characterphoto)
  end

  def addskill_params
    params.require(:characterskill).permit(:skill_id, :favoredfoe, :chosenelement, :acquiredate)
  end

  def addprof_params
    params.require(:characterprofession).permit(:profession_id)
  end

  def sendcourier_params
    params.require(:courier).permit(:type, :recipient, :destination, :message, :skillsused)
  end

  def backstory_params
    params.require(:backstory).permit(:backstory)
  end

  def check_character_count
    if current_user.charactercount <= current_user.characters.count
      redirect_to player_characters_path
      return true
    end
    false
  end

  def check_character_user
    if session[:character]
      if (current_user.id != Character.find(session[:character]).user_id) && (current_user.usertype != 'Admin')
        redirect_to root_path
        return true
      end
      @character = Character.find(session[:character])
      false
    end
  end

  def check_sheets_locked
    if get_sheets_locked
      redirect_to player_characters_path
      return true
    end
    false
  end

  

end
