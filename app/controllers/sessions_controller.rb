# File: sessions_controller.rb
# Purpose: Controller of sessions. 
# License : LGPL. No copyright.

# This controller contains the logic involved 
# to log user in and out of the application
# and creates home page.

class SessionsController < ApplicationController

  # name: new
  # explanation: set home_page object as true
  # parameters:
  # -none
  # return: home_page object

  def new
    @home_page = true
   
    assert(@home_page.kind_of?(SessionsController))

    return @home_page
  end

  # name: log_user_in
  # explanation: log in 
  # parameters:
  # -none
  # return: message of sucess or render new

  def log_user_in
    user = User.find_by(email: params[:session][:email].downcase)

    assert(@user.kind_of?(User))

    if user && user.authenticate(params[:session][:password])
      log_in(user)
      redirect_to(root_path)
      return flash[:success] = t(:logged)
    else
      flash.now[:danger] = t(:invalid)
      render('new')
    end

  end

  # name: log_user_out
  # explanation: log out
  # parameters:
  # -none
  # return: login_path

  def log_user_out

    if current_user
      log_out
    else
      #nothing to do
    end

    return redirect_to(login_path)
  end

end



