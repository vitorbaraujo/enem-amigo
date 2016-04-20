class SessionsController < ApplicationController

  # name: new
  # explanation: set home_page object as true
  # parameters:
  # -none
  # return: home_page object

  def new
    return @home_page = true
  end

  # name: log_user_in
  # explanation: log in 
  # parameters:
  # -none
  # return: message of sucess or render new

  def log_user_in
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      log_in (user)
      redirect_to (root_path)
      return flash[:success] = "Logado com sucesso!"
    else
      flash.now[:danger] = 'Combinação inválida de e-mail/senha'
      render ('new')
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
    
    return redirect_to (login_path)
  end

end
