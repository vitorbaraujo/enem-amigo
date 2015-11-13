class BattlesController < ApplicationController

  include BattlesHelper

  before_action :verify_processed, only: [:finish]
  before_action :verify_participation, only: [:show]
  before_action :verify_played, only: [:result]

  def new
    @battle = Battle.new
  end

  def create
    @battle = Battle.new(player_1: current_user, player_2: User.where(nickname: params[:player_2_nickname]).first)
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
    battle_answer_notification(@battle, true) unless is_player_1?(@battle)
    @question = @battle.questions[0]
  end

  def index
    @battles = current_user.battles.reverse
  end

  def destroy
    @battle = Battle.find(params[:id])
    battle_answer_notification(@battle, false)
    @battle.destroy
    redirect_to battles_path
  end

  def answer
    battle = Battle.find(params[:id])

    question = battle.questions[question_number(battle)]
    @answer_letter = params[:alternative]

    unless params[:alternative].blank?
      question.update_attribute(:users_tries, question.users_tries + 1)

      @correct_answers = (@answer_letter == question.right_answer)
      question.update_attribute(:users_hits, question.users_hits + 1) if @correct_answer
      if is_player_1?(battle)
        battle.player_1_answers[question_number(battle)] = @answer_letter
      else
        battle.player_2_answers[question_number(battle)] = @answer_letter
      end
      battle.save
    end

    if is_last_question?(battle)
      process_time(battle)
      flash[:success] = "Batalha finalizada com sucesso!"
      render :js => "window.location.href += '/finish'"
    else
      @question = battle.questions[question_number(battle)]
    end
  end

  def finish
    @battle = Battle.find(params[:id])
    player_answers = is_player_1?(@battle) ? @battle.player_1_answers : @battle.player_2_answers
    @answers = @battle.questions.zip(player_answers)
  end

  def result
    @battle = Battle.find(params[:id])

    if @battle.processed?
      count_questions
    else
      process_result
    end

    if is_player_1?(@battle)
      current_player_answers = @battle.player_1_answers
      adversary_answers = @battle.player_2_answers
      @current_player_points = @player_1_points
      @adversary_points = @player_2_points
    else
      current_player_answers = @battle.player_2_answers
      adversary_answers = @battle.player_1_answers
      @current_player_points = @player_2_points
      @adversary_points = @player_1_points
    end

    @answers = @battle.questions.zip(current_player_answers, adversary_answers)
  end

  def generate_random_user
    random_user = (User.all - [current_user]).sample

    render :text => random_user.nickname
  end
end