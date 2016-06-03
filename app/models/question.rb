# File: question.rb
# Purpose: Maintain logic for question.
# License: LGPL. No copyright.

# This class represents the information on question model

class Question < ActiveRecord::Base

  before_save { self.area = area.mb_chars.downcase.to_s }
  before_save { self.right_answer = right_answer.downcase }

  validates :year, presence: true, length: { maximum: 4 }
  validates :area, presence: true
  validates :number, presence: true, length: { maximum: 3 }
  validates :enunciation, presence: true
  validates :alternatives, presence: true
  validates :right_answer, presence: true, length: { maximum: 1 }
  validates :number, uniqueness: { scope: [:year] }

  has_many :texts

  validate do
    check_alternatives_number
  end

  has_many :alternatives
  has_and_belongs_to_many :battles
  accepts_nested_attributes_for :alternatives, allow_destroy: true

  ALTERNATIVES_COUNT = 5

 # name: hit_rate
 # explanation: this method calculates hit rate
 # parameters:
 # -none
 # return: hit_rateh
  def hit_rate
    if self.tries == 0 
      hit_rate ||= 0
    else
      hit_rate ||= (100 * (self.hits.to_f / self.tries)).round(2)
    end 
    return hit_rate
  end

 # name: next_questions
 # explanation: this method redirects to next question 
 # parameters:
 # -none
 # return: question of enemamigo
  def next_question
    question ||= Question.where(area: self.area).where("id > ?", id).first
    if !question
      question = Question.where(area: self.area).first
    else
      # nothing to do
    end
      return question 
  end

 # name: users_hit_rate
 # explanation: this method calculates hit rate of user 
 # parameters:
 # -none
 # return: users_hit_rate of enemamigo
  def users_hit_rate
    if self.users_tries == 0
      users_hit_rate ||= 0
    else
      users_hit_rate ||= (100 * (self.users_hits.to_f / self.users_tries)).round(2)
    end
      return users_hit_rate
  end


 # name: total_hit_rate
 # explanation: this method calculates total hit rate 
 # parameters:
 # -none
 # return: total_hit_rate
  def total_hit_rate
    total_hit_rate = (100 * (self.hits + self.users_hits.to_f) / (self.tries + self.users_tries)).round(2)
    if total_hit_rate.nan?
        total_hit_rate ||= 0.0
    else
      # nothing to do
    end
    return total_hit_rate
  end

 # name: data
 # explanation: this method return an hash with data for comparison
 # parameters:
 # -none
 # return: data
  def data
    [
      {"name" => "Enem","data" => {"Enem" => self.hit_rate}},
      {"name" => "Usuários","data" => {"Usuários" => self.users_hit_rate}},
      {"name" => "Todos","data" => {"Todos" => self.total_hit_rate}}
    ]
  end

  class << self
 # name: method_missing
 # explanation: this method calculates hit rate
 # parameters:
 # -none
 

 # return: question of enemamigo
    def method_missing method_name, *args
      method_name = method_name.to_s
      if method_name.slice! /_questions/
        cmp_hash = { "beginner" => lambda { |hit_rate| hit_rate >= 75.0 },
                     "intermediate" => lambda { |hit_rate| hit_rate >= 30.0 && hit_rate < 75.0 },
                     "advanced" => lambda { |hit_rate| hit_rate < 30.0 } }
        questions = Question.where area: args.first
        questions.select { |q| cmp_hash[method_name].call q.total_hit_rate }
      else
        super
      end
    end
  end

  private

 # name: alternatives_count_valid?
 # explanation: this method validates amount of alternatives 
 # parameters:
 # -none
 # return: alternatives of user
    def alternatives_count_valid?
      self.alternatives.size == ALTERNATIVES_COUNT
    end

 # name: check_alternatives_number
 # explanation: this method check number of alternatives
 # parameters:
 # -none
 # return: alternatives of user
    def check_alternatives_number
      if !alternatives_count_valid?
        errors.add(:alternatives, "cannot be less than 5")
      else
        # nothing to do
      end
    end
end