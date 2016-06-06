# File: static_pages_controller.rb
# Purpose: Maintain logic for static pages.
# License: LGPL. No copyright.

# This controller contain actions to redirect to certain views in system, like
# home, about, help and server error.

class StaticPagesController < ApplicationController

  before_action :authenticate_user, only: [:home]

  # name: home
  # explanation: this method exists only to lead to the action's view, but finds medals and level of user
  # parameters:
  # - none
  # return: level from user
  def home
    check_medals()

    assert(current_user.kind_of?(User))
    
    return find_level(current_user.points)
  end

  # name: about
  # explanation: exists only to lead to the action's view
  # parameters:
  # - none
  # return: none
  def about
  end

  # name: help
  # explanation: exists only to lead to the action's view
  # parameters:
  # - none
  # return: none
  def help
  end

  # name: server_error
  # explanation: this method checks if there are no errors
  # parameters:
  # - none
  # return: redirection to root_path
  def server_error
    if !session[:exception]
      redirect_to_back(root_path)
    else
      # do nothing
    end
    return session.delete(:exception)
  end

end
