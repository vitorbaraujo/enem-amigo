class BattlesController < ApplicationController

  include BattlesHelper

  before_action :authenticate_user
  before_action :verify_participation, only: [:show, :destroy]
  before_action :verify_all_played, only: [:result]
  before_action :verify_current_user_played, only: [:finish]

  EMPTY_ARRAY = []

  def new
    @battle = Battle.new

    return @battle
  end

  def create
    player_2_user = User.where(nickname: params[:player_2_nickname]).first

    @battle = Battle.new(player_1: current_user, player_2: player_2_user)
    @battle.category = params[:battle][:category]
    @battle.generate_questions

    if @battle.save
      new_battle_notification(@battle)

      flash[:success] = "Convite enviado com sucesso!"
      redirect_to battles_path
    else
      flash[:danger] = "Usuário não encontrado"
      render 'new'
    end
  end

  def show
    @battle = Battle.find(params[:id])

    start_battle(@battle)

    if is_player_1(@battle)
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

  def index
    @pending_battles = EMPTY_ARRAY
    @waiting_battles = EMPTY_ARRAY
    @finished_battles = EMPTY_ARRAY
    @battles = current_user.battles.reverse

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

  def destroy
    @battle = Battle.find(params[:id])
    battle_answer_notification(@battle, false)
    @battle.destroy

    redirect_to battles_path
  end

  def ranking
    @users = User.order(:wins, :battle_points).reverse

    return @users
  end

  def answer
    battle = Battle.find(params[:id])

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
      flash[:success] = "Batalha finalizada com sucesso!"
      render :js => "window.location.href += '/finish'"
    else
      @question = battle.questions[question_position]
    end
  end

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

  def generate_random_user
    users_except_current = User.all - [current_user]

    random_user = users_except_current.sample

    render :text => random_user.nickname
  end
end

