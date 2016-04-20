class Battle < ActiveRecord::Base

  has_and_belongs_to_many :questions
  has_many :notifications
  belongs_to :player_1, class_name: 'User'
  belongs_to :player_2, class_name: 'User'
  belongs_to :winner, class_name: 'User'

  serialize :player_1_answers, Array
  serialize :player_2_answers, Array

  validates :player_2, presence: true

  EMPTY_STRING = ""

  def generate_questions
    if self.category == EMPTY_STRING
      self.questions = Question.all
      return self.questions.sample(10)
    else
      self.questions = Question.where(area: self.category)
      return self.questions.sample(10)
    end
  end

  def all_played?
    both_players_started = self.player_1_start and self.player_2_start
    return both_players_started
  end

end

