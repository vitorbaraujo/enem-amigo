class MedalsController < ApplicationController

  before_action :authenticate_user

  # name: index
  # explanation: this method checks all medals a user doesn't have to display in the view
  # parameters:
  # - none
  # return: medals a user doesn't have
  def index
    check_medals()
    assert(current_user.kind_of?(User))
    @missing_medals = @medals - current_user.medals
    return @missing_medals
  end

end
