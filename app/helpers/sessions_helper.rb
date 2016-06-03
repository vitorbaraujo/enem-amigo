# File: sessions_helper.rb
# Purpose: Maintain logic for sessions.
# License: LGPL. No copyright.

# This helper contains auxiliary methods that be used to manage the login procedures. 

module SessionsHelper

 # name: log_in
 # explanation: this method check if user logged 
 # parameters:
 # -none
 #return: user of enemamigo
  def log_in(user)
    session[:user_id] ||= user.id
  end

 # name: current_user
 # explanation: this method level of user without updating it
 # parameters:
 # -none
 #return: current_user
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

 # name: logged_in
 # explanation: this method check if user logged 
 # parameters:
 # -none
 #return: logged of enemamigo
  def logged_in?
    !current_user.nil?
  end

 # name: log_out
 # explanation: this method check if user log out
 # parameters:
 # -none
 #return: log_out of enemamigo
  def log_out
    session.delete(:user_id)
    @current_user ||= nil
  end

 # name: authenticate_user
 # explanation: this method check the authenticate of user
 # parameters:
 # -none
 #return: redirect_to login_path 
  def authenticate_user
    if !logged_in?
      return redirect_to login_path 
    else
      # nothing to do
    end
  end

 # name: authenticate_admin
 # explanation: this method check the authenticate of admin
 # parameters:
 # -none
 #return: authenticate_admin of enemamigo
  def authenticate_admin
    if !current_user.role_admin?
      redirect_to_back(root_path) 
    else
      # nothing to do
    end
  end

 # name: verify_user_permission
 # explanation: this method the veriry permission of user
 # parameters:
 # -none
 #return: user of enemamigo
  def verify_user_permission
    user ||= User.find(params[:id])
    if !(user.id == current_user.id || current_user.role_admin?)
      redirect_to_back(users_path)
    else
      # nothing to do
    end 
  end

 # name: redirect_to_back
 # explanation: this method the redirect to back
 # parameters:
 # -none
 #return: redirect_to_back
  def redirect_to_back(default = root_path)
    if !request.env["HTTP_REFERER"].blank? && request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
      redirect_to :back
    else
      redirect_to default
    end
  end

end
