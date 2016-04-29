module MedalsHelper

  EMPTY_ARRAY = []

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

  def achieved(medal)
    medal.achieved_instructions.map { |instruction| eval instruction }
  end

  def message(medal)
    medal.message_instructions.map { |instruction| eval instruction }
  end

end

