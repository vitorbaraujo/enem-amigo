# File: medals_controller.rb
# Purpose: Maintain logic for medals.
# License: LGPL. No copyright.

# This controller sets the behavior for showing medals a user does not have.


class MedalsController < ApplicationController

  before_action :authenticate_user

  # name: index
  # explanation: this method checks all medals a user doesn't have to display in the view
  # parameters:
  # - none
  # return: medals a user doesn't have


  def index
    @NONE = 0
    check_medals()

    assert(current_user.kind_of?(User))

    @missing_medals = @medals - current_user.medals

    if @missing_medals != @NONE
      @missing_medals.each do |medal|
        assert(medal.kind_of?(Medal))
      end
    else
      # nothing to do
    end

    return @missing_medals
  end

end
