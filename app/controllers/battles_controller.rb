# File: battles_controller.rb
# Purpose: Implementation of the Battle Controller
# License: LGPL. No copyright.

# This controller contains the logic involving creating, reading, updating and
# deleting battles between two users, in addition to manage the results of a
# single battle

class BattlesController < ApplicationController

  include BattlesHelper

  EMPTY_ARRAY = []

  before_action :authenticate_user
  before_action :verify_participation, only: [:show, :destroy]
  before_action :verify_all_played, only: [:result]
  before_action :verify_current_user_played, only: [:finish]

  # name: new
  # explanation: instantiates a new battle object
  # parameters:
  # - none
  # return: a battle object
  def new
    @battle = Battle.new
    assert(@battle.kind_of?(Battle))

    return @battle
  end

  # name: create
  # explanation: fills the battle object with parameters given
  # parameters:
  # - none
  # return: void
  def create
    player_2_user = User.where(nickname: params[:player_2_nickname]).first
    assert(player_2_user.kind_of?(User))

    @battle = Battle.new(player_1: current_user, player_2: player_2_user)
    assert(@battle.kind_of?(Battle))

    @battle.category = params[:battle][:category]
    @battle.generate_questions

    if @battle.save
      new_battle_notification(@battle)

      flash[:success] = t(:invitation_battle)
      redirect_to battles_path
    else
      flash[:danger] = t(:user_not_found)
      render 'new'
    end
  end

  # name: show
  # explanation: displays a single battle given an identifier
  # parameters:
  # - none
  # return: void
  def show
    @battle = Battle.find(params[:id])

    start_battle(@battle)

    if is_player_1?(@battle)
      # nothing to do
    else
      battle_answer_notification(@battle, true)
    end

    if is_player_1?(@battle)
      @adversary = @battle.player_2
    else
      @adversary = @battle.player_1
    end

    @question = @battle.questions.first
  end

  # name: index
  # explanation: show a list of battles
  # parameters:
  # - none
  # return: three array of battles (pending, waiting and finished battles)
  def index
    @pending_battles = EMPTY_ARRAY
    @waiting_battles = EMPTY_ARRAY
    @finished_battles = EMPTY_ARRAY

    @battles = current_user.battles.reverse
    assert(@battles.kind_of?(Array))

    @battles.each do |battle|
      if battle.all_played?
        @finished_battles.push(battle)
      elsif player_started?(battle)
        @waiting_battles.push(battle)
      else
        @pending_battles.push(battle)
      end
    end
  end

  # name: destroy
  # explanation: destroy a single battle given an identifier
  # parameters:
  # - none
  # return: void
  def destroy
    @battle = Battle.find(params[:id])
    assert(@battle.kind_of?(Battle))

    battle_answer_notification(@battle, false)
    @battle.destroy

    redirect_to battles_path
  end

  # name: ranking
  # explanation: displays a ranking of users by their battle points
  # parameters:
  # - none
  # return: a relation of users as described above
  def ranking
    @users = User.order(:wins, :battle_points).reverse

    return @users
  end

  # name: answer
  # explanation: fills battle attributes by answers given by user
  # parameters:
  # - none
  # return: void
  def answer
    battle = Battle.find(params[:id])

    assert(battle.kind_of?(Battle))

    question_position = question_number(battle)

    question = battle.questions[question_position]
    @answer_letter = params[:alternative]

    if not params[:alternative].blank?
      # nothing to do
    else
      new_question_tries = question.users_tries + 1
      question.update_attribute(:users_tries, new_question_tries)

      @correct_answer = (@answer_letter == question.right_answer)

      if @correct_answer
        question.update_attribute(:users_hits, question.users_hits + 1)
      else
        # nothing to do
      end

      if is_player_1?(battle)
        battle.player_1_answers[question_position] = @answer_letter
      else
        battle.player_2_answers[question_position] = @answer_letter
      end

      question_position = question_position.succ
      battle.save
    end

    if question_position == battle.questions.count
      process_time(battle)
      flash[:success] = t(:finish_battle)
      render :js => "window.location.href += '/finish'"
    else
      @question = battle.questions[question_position]
    end
  end

  # name: finish
  # explanation: calculates the winner and points of the battle, when this
  #  finishes
  # parameters:
  # - none
  # return: points of player who won the battle
  def finish
    @battle = Battle.find(params[:id])

    if is_player_1?(@battle)
      player_answers = @battle.player_1_answers
    else
      player_answers = @battle.player_2_answers
    end

    @answers = @battle.questions.zip(player_answers)
    player_comparison = @answers.map { |x, y| x.right_answer == y }
    player_comparison.delete(false)

    @player_points = player_comparison.count

    return @player_points
  end

  # name: result
  # explanation: displays results of a battle, like the time spent for each
  #  user, and their points
  # parameters:
  # - none
  # return:
  def result
    @battle = Battle.find(params[:id])

    if @battle.processed?
      count_questions
    else
      process_result
    end

    @battle.reload

    if is_player_1?(@battle)
      current_player_answers = @battle.player_1_answers
      adversary_answers = @battle.player_2_answers
      @current_player_stats = [@player_1_points, @battle.player_1_time]
      @adversary_stats = [@player_2_points, @battle.player_2_time]
    else
      current_player_answers = @battle.player_2_answers
      adversary_answers = @battle.player_1_answers
      @current_player_stats = [@player_2_points, @battle.player_2_time]
      @adversary_stats = [@player_1_points, @battle.player_1_time]
    end

    if @current_player_stats.second >= 610
      @current_player_stats[1] = "--:--"
    else
      minutes_string = "#{@current_player_stats.second / 60}"
      seconds_string = ":"

      if @current_player_stats.second % 60 < 10
        second_string = second_string + "0"
      else
        # nothing to do
      end

      seconds_mod = "#{@current_player_stats.second % 60}"
      second_string = second_string + seconds_mod

      @current_player_stats[1] = minutes_string + seconds_string
    end

    if @adversary_stats.second >= 610
      @adversary_stats[1] = "--:--"
    else
      minutes_string = "#{@adversary_stats.second / 60}"
      seconds_string = ":"

      if @adersary_stats.second % 60 < 10
        second_string = second_string + "0"
      else
        # nothing to do
      end

      seconds_mod = "#{@adersary_stats.second % 60}"
      second_string = second_string + seconds_mod

      @adversary_stats[1] = minutes_string + seconds_string
    end

    @answers = @battle.questions.zip(current_player_answers, adversary_answers)
  end

  # name: generate_random_user
  # explanation: generate a random user to play the battle with, if the user
  #  choses to battle with a random person
  # parameters:
  # - none
  # return: void
  def generate_random_user
    users_except_current = User.all - [current_user]

    random_user = users_except_current.sample

    render :text => random_user.nickname
  end
end
