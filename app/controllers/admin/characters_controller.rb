class Admin::CharactersController < AdminController
  def get_characters_by_email
    @characters = Character.where('user_id = ?', User.select('id').where('email = ?', params[:email])

    
  end 
  
  def index
    @characters = Character.all
    @users = User.all
  end

  def new
    setup_character_lists
    @character = Character.new
  end

  def show
    @user = User.find(params[:user_id])
    @character = Character.find(params[:id])
  end

  def create
    @character = Character.new(character_params)
    @character.user_id = params[:user_id]
    if @character.save
      redirect_to admin_user_path(params[:user_id])
    else
      setup_character_lists
      render 'new'
    end
  end

  def edit
    @character = Character.find(params[:id])
    @character.user_id = params[:user_id]
    setup_character_lists
  end

  def update
    @character = Character.find(params[:id])

    if @character.update(character_params)
      redirect_to admin_character_path(@character)
    else
      render 'edit'
    end
  end

  def destroy
    @character = Character.find(params[:id])
    @character.destroy
  
    redirect_to admin_user_path(params[:user_id])
  end
  
  private

  def character_params
    params.require(:character).permit(:name, :pronouns, :deity_id, :race_id, :characterclass_id, :user_id)
  end

  def setup_character_lists
    @user = User.find(params[:user_id])
    @classes = Characterclass.select { |x| x.playeravailable == true }
    @races = Race.select { |x| x.playeravailable == true }
    @deities = Deity.select { |x| x.playeravailable == true }
  end
  
end
