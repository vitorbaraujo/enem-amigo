# File: battles_helper.rb
# Purpose: Implementation of the Battles Helper
# License: LGPL. No copyright.

# This helper contains auxiliar methods to be used in the controller of the
# battle to do lots of checking, i.e., checking if a battle has started of
# finished, in addition to check who is participating in a given battle

module BattlesHelper

  INICIAL_BATTLE_ANSWERS = ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.']
  WIN_POINTS_BATTLE = 25

  # name: player_started?
  # explanation: checks if the current player has started the battle
  # parameters:
  # - battle: object
  # return: true if the player started the battle, false otherwise
  def player_started?(battle)
    if is_player_1?(battle)
      return battle.player_1_start
    else
      return battle.player_2_start
    end
  end

  # name: start_battle
  # explanation: assign initial settings to a battle when this one starts
  # parameters:
  # - battle: object
  # return: a battle with the settings assigned
  def start_battle(battle)
  	if is_player_1?(battle)
  		battle.player_1_start = true
      battle.player_1_answers = INICIAL_BATTLE_ANSWERS
      battle.player_1_time = Time.now.to_i
      battle.save
  	else
  		battle.player_2_start = true
      battle.player_2_answers = INICIAL_BATTLE_ANSWERS
      battle.player_2_time = Time.now.to_i
      battle.save
  	end

    return battle
  end

  # name: is_player_1
  # explanation: checks if current player is player_1 of the battle
  # parameters:
  # - battle: object
  # return: true if the current player is player_1, false otherwise
  def is_player_1?(battle)
    return current_user == battle.player_1
  end

  # name: process_result
  # explanation: assigns results to the battle when this one ends
  # parameters:
  # - none
  # return: a battle with all the parameters assigned
  def process_result
    battle = Battle.find(params[:id])

    count_questions

    player_1 = battle.player_1
    player_2 = battle.player_2

    new_player_1_battle_points = player_1.battle_points + @player_1_points
    new_player_2_battle_points = player_2.battle_points + @player_2_points

    player_1.update_attribute(:battle_points, new_player_1_battle_points)
    player_2.update_attribute(:battle_points, new_player_2_battle_points)

    if battle.player_1_time > 600
      battle.update_attribute(:player_1_time, 600)
    else
      # nothing to do
    end

    if battle.player_2_time > 600
      battle.update_attribute(:player_2_time, 600)
    else
      # nothing to do
    end

    p1_has_more_points = @player_1_points > @player_2_points
    players_same_points = @player_1_points == @player_2_points
    p1_has_less_time = battle.player_1_time <= battle.player_2_time

    if(p1_has_more_points || (players_same_points && p1_has_less_time))
      battle.update_attribute(:winner, player_1)

      new_player_1_wins = player_1.wins + 1
      player_1.update_attribute(:wins, new_player_1_wins)

      new_player_1_battle_points = player_1.battle_points + WIN_POINTS_BATTLE
      player_1.update_attribute(:battle_points, new_player_1_battle_points)
    else
      battle.update_attribute(:winner, player_2)

      new_player_2_wins = player_2.wins + 1
      player_2.update_attribute(:wins, new_player_2_wins)

      new_player_2_battle_points = player_2.battle_points + WIN_POINTS_BATTLE
      player_2.update_attribute(:battle_points, new_player_2_battle_points)
    end

    battle.update_attribute(:processed, true)

    return battle
  end

  # name: verify_participation
  # explanation: checks if user has already participated the battle
  # parameters:
  # - none
  # return: void
  def verify_participation
    battle = Battle.find(params[:id])

    if player_started?(battle)
      flash[:danger] = "Você já participou desta batalha"
      redirect_to battles_path
    end
  end

  # name: verify_all_played
  # explanation: checks if both players have played the battle
  # parameters:
  # - none
  # return: void
  def verify_all_played
    battle = Battle.find(params[:id])

    if battle.all_played?
      # nothing to do
    else
      flash[:danger] = "A batalha ainda não foi finalizada"
      redirect_to battles_path
    end
  end

  # name: verify_current_user_played
  # explanation: checks if the current player has played the battle
  # parameters:
  # - none
  # return: void
  def verify_current_user_played
    battle = Battle.find(params[:id])

    if player_started?(battle)
      # nothing to do
    else
      flash[:danger] = "Você ainda não participou dessa batalha"
      redirect_to battles_path
    end
  end

  # name: count_questions
  # explanation: counts how many questions each players got right
  # parameters:
  # - none
  # return: void
  def count_questions
    p1_comp = @battle.questions.zip(@battle.player_1_answers)
    p1_comp = p1_comp.map { |x, y| x.right_answer == y }
    player_1_comparison = p1_comp

    p2_comp = @battle.questions.zip(@battle.player_1_answers)
    p2_comp = p2_comp.map { |x, y| x.right_answer == y }
    player_2_comparison = p2_comp

    player_1_comparison.delete(false)
    player_2_comparison.delete(false)

    @player_1_points = player_1_comparison.count
    @player_2_points = player_2_comparison.count
  end

  # name: process_time
  # explanation: process time that the current player spent in the battle
  # parameters:
  # - battle: object
  # return: void
  def process_time(battle)
    if is_player_1?(battle)
      new_player_1_time = Time.now.to_i - battle.player_1_time
      battle.update_attribute(:player_1_time, new_player_1_time)
    else
      new_player_2_time = Time.now.to_i - battle.player_2_time
      battle.update_attribute(:player_2_time, new_player_2_time)
    end
  end

  # name: question_number
  # explanation: counts how many questions the current player answered
  # parameters:
  # - battle: object
  # return: number of questions as described above
  def question_number(battle)
    if is_player_1?(battle)
      answers = battle.player_1_answers
    else
      answers = battle_player_2_answers
    end

    answers = answers - ['.']
    count_questions = answers.count

    return count_questions
  end

end
