class MedalsController < ApplicationController

  before_action :authenticate_user

  def index
    check_medals()
    assert(current_user.kind_of?(User))
    @missing_medals = @medals - current_user.medals
    return @missing_medals
  end

end
