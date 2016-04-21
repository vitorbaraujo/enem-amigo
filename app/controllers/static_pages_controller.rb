class StaticPagesController < ApplicationController

  before_action :authenticate_user, only: [:home]

  def home
    check_medals
    return find_level(current_user.points)
  end

  def about
  end

  def help
  end

  def server_error
    if !session[:exception]
      redirect_to_back(root_path)
    else
      # do nothing
    end
    return session.delete(:exception)
  end

end
