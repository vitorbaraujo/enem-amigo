# File: battle.rb
# Purpose: Implementation of the class Battle
# License: LGPL. No copyright.

# This class contains the implementation of a battle between two users, and it
# also contains methods to regulate the battle

class Battle < ActiveRecord::Base

  EMPTY_STRING = ""
  QUESTIONS_IN_A_BATTLE = 10

  has_and_belongs_to_many :questions
  has_many :notifications

  belongs_to :player_1, class_name: 'User'
  belongs_to :player_2, class_name: 'User'
  belongs_to :winner, class_name: 'User'

  serialize :player_1_answers, Array
  serialize :player_2_answers, Array

  validates :player_2, presence: true

  # name: generate_questions
  # explanation: this method creates a set of questions of a given category,
  #   or from all questions, if no category is given
  # parameters:
  # - none
  # return: 10 questions as described above
  def generate_questions
    category = self.category
    questions = self.questions
    if category == EMPTY_STRING
      questions = Question.all
      return questions.sample(QUESTIONS_IN_A_BATTLE)
    else
      questions = Question.where(area: category)
      return questions.sample(QUESTIONS_IN_A_BATTLE)
    end
  end

  # name: all_played?
  # explanation: checks if both players have started the battle
  # parameters:
  # - none
  # return: true if both players started the battle, false otherwise
  def all_played?
    both_players_started = self.player_1_start and self.player_2_start
    return both_players_started
  end

end
