# File: users_controller.rb
# Purpose: Maintain logic for users.
# License: LGPL. No copyright.

# This controller contain general methods regarding users objects, including
# actions to create, read, destroy, update users and create ranking for them,
# as well as actions regarding profile image.

class UsersController < ApplicationController

  @NONE = 0
  before_action :authenticate_user, except: [:ranking, :new, :create]
  before_action :verify_user_permission, only: [:edit, :destroy]

  # name: new
  # explanation: this method creates a new object of class User
  # parameters:
  # - none
  # return: if logged in, redirect to user's page.
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

  # name: edit
  # explanation: this method finds a user with a given id
  # parameters:
  # - none
  # return: returns the user found
  def edit
    @user = User.find(params[:id])

    assert(@user.kind_of?(User))

    return @user
  end

  # name: destroy
  # explanation: this method finds and destroy a User with given id
  # parameters:
  # - none
  # return: redirection to login
  def destroy
    assert(params[:id].kind_of?(Fixnum))

    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = t(:delete_user)
    return redirect_to(users_path)
  end

  # name: show
  # explanation: this method finds a user with a given id
  # parameters:
  # - none
  # return: Because of view, will redirect to a page with user's info
  def show
    assert(params[:id].kind_of?(Fixnum))

    @user = User.find(params[:id])

    assert(@user.kind_of?(User))

    return find_level(current_user.points)
  end

  # name: create
  # explanation: this method creates a user with info collected from a form
  # parameters:
  # - none
  # return: redirect's to homepage if success
  def create
    assert(!user_params.nil?)

    @user = User.new(user_params)

    if @user.save
      flash[:success] = t(:create_user)
      log_in(@user)
      first_notification
      return redirect_to(root_path)
    else
      @home_page = true
      return render('new')
    end
  end

  # name: destroy
  # explanation: this method gets user from edit and updates it's info
  # parameters:
  # - none
  # return: redirection to user's page
  def update
    assert(params[:id].kind_of?(Fixnum))

    @user = User.find(params[:id])

    assert(@user.kind_of?(User))

    if @user.update_attributes(user_params)
      flash[:success]= t(:update_user)
      return redirect_to(@user)
    else
      return render('edit')
    end
  end

  # name: destroy
  # explanation: this method gets all users from the system
  # parameters:
  # - none
  # return: Variable with all users
  def index
    @users = User.all
    return @users
  end

  # name: ranking
  # explanation: this method gets all users and ordem them based on their points
  # parameters:
  # - none
  # return: returns all users ordered
  def ranking
    if !logged_in?
      @home_page = true
    else
      # nothing to do
    end
      @users = User.order(:points).reverse
      return @users
  end

  # name: delete_profile_image
  # explanation: this method deletes a user's profile image
  # parameters:
  # - none
  # return: redirection to user's page
  def delete_profile_image
    if !current_user.profile_image_file_name.empty?
      current_user.update_attribute(:profile_image_file_name,"")
      flash[:success] = t(:delete_photo)
    else
      flash[:danger] = t(:error_delete_photo)
    end
    return redirect_to(user_path(current_user.id))
  end

  private

  # name: user_params
  # explanation: this method specifies what attributes can be collected in form
  # parameters:
  # - none
  # return: none
  def user_params
    params.require(:user).permit(:name, :email, :level, :points, :nickname, :password_digest,:password, :password_confirmation, :profile_image)
  end

end
