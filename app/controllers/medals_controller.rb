class MedalsController < ApplicationController

  before_action :authenticate_user

  def index
    check_medals
    return @missing_medals = @medals - current_user.medals
  end

end
