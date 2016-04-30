class UsersController < ApplicationController

  before_action :authenticate_user, except: [:ranking, :new, :create]
  before_action :verify_user_permission, only: [:edit, :destroy]

  def new
    @home_page = true
    @user = User.new
    assert(@user.kind_of?(User))

    if logged_in?
        return redirect_to(current_user)
    else
    end
    # nothing to do
  end

  def edit
    @user = User.find(params[:id])
    assert(@user.kind_of?(User))
    return @user
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "Usuário foi deletado"
    return redirect_to(users_path)
  end

  def show
    @user = User.find(params[:id])
    assert(@user.kind_of?(User))
    return find_level(current_user.points)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "Usuário criado com sucesso!"
      log_in(@user)
      first_notification
      return redirect_to(root_path)
    else
      @home_page = true
      return render('new')
    end
  end

  def update
    @user = User.find(params[:id])
    assert(@user.kind_of?(User))
    if @user.update_attributes(user_params)
      flash[:success]= "Usuário atualizado"
      return redirect_to(@user)
    else
      return render('edit')
    end
  end

  def index
    @users = User.all
    return @users
  end

  def ranking
    if !logged_in?
      @home_page = true
    else
      # nothing to do
    end
      @users = User.order(:points).reverse
      return @users
  end

  def delete_profile_image
    if !current_user.profile_image_file_name.empty?
      current_user.update_attribute(:profile_image_file_name,"")
      flash[:success] = "Foto de perfil removida com sucesso!"
    else
      flash[:danger] = "Não há foto de perfil para ser removida."
    end
    return redirect_to(user_path(current_user.id))
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :level, :points, :nickname, :password_digest,:password, :password_confirmation, :profile_image)
  end

end
