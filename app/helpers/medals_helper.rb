# File: medals_helper.rb
# Purpose: Implementation of the Medals Helper
# License: LGPL. No copyright.

# This helper contains auxiliar methods to be used in the controller of medals
# to deal with how many medals a single user has or check if a medal has been
# defined correctly

module MedalsHelper
  EMPTY_ARRAY = []

  # name: check_medals
  # explanation: checks which medals the curent user has
  # parameters:
  # - none
  # return: void
  def check_medals
    @medals = Medal.all
    @new_medals = EMPTY_ARRAY

    missing_medals = @medals - current_user.medals

    missing_medals.each do |missing_medal|
      achieved_medal = achieved(missing_medal)

      if achieved_medal
        current_user.medals << missing_medal
        @new_medals.push(missing_medal)
      else
        # nothing to do
      end
    end
  end

  # name: achieved
  # explanation: evaluates instructions of the medal if a user achives this one
  # parameters:
  # - medal: object
  # return: void
  def achieved(medal)
    medal.achieved_instructions.map { |instruction| eval instruction }
  end

  # name: message
  # explanation: evaluates instructions of the medal when this one is displayed
  # parameters:
  # - medal: object
  # return: void
  def message(medal)
    medal.message_instructions.map { |instruction| eval instruction }
  end

end
