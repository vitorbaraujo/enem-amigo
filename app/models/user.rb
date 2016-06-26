# File: user.rb
# Purpose: Implementation of user's class
# License : LGPL. No copyright.

# The class user is the main class of the system, because it contains
# all information about one's progress in the website, in example place in
# ranking, number of right questions, etc

class User < ActiveRecord::Base
  NONE = 0
  BEGGINER = 30
  INTERMEDIATE = 60

  has_many :active_battles, class_name: 'Battle', foreign_key: 'player_1_id'
  has_many :passive_battles, class_name: 'Battle', foreign_key: 'player_2_id'
  has_many :won_battles, class_name: 'Battle', foreign_key: 'winner'
  has_many :notifications
  has_and_belongs_to_many :medals

  serialize :accepted_questions, Array
  serialize :answered_exams, Array
  serialize :tried_questions, Array
  serialize :exam_performance, Array

  before_save { self.email = email.downcase }

  has_secure_password

  has_attached_file :profile_image
  validates_attachment :profile_image,
      content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }

  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length:{maximum: 60}
  validates :nickname, presence: true, length:{maximum: 40}, uniqueness: true
  validates :email, presence: true, length:{maximum: 255},
  format: { with:  VALID_EMAIL },
  uniqueness: { case_sensitive: false }
  validates :password, length:{minimum: 8}, presence: true

  # name: User.digest
  # explanation: creates a safe encrypted password for user
  # parameters:
  # - string: password defined by user
  # return: none
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    BCrypt::Password.create(string, cost: cost)
  end

  # name: count_questions_by_area
  # explanation: counts right questions of User in a given area
  # parameters:
  # - area: string that represents the area of the question
  # return: all right questions in the area
  def count_questions_by_area(area)
    right_questions_in_area = 0
    self.accepted_questions.each do |t|
      if Question.find(t).area == area
        right_questions_in_area = right_questions_in_area+1
      else
        # nothing to do
      end
    end
    return right_questions_in_area
  end

  # name: find_position_in_raking
  # explanation: Finds a user position in system's ranking by points
  # parameters:
  # - none
  # return: position in ranking
  def find_position_in_ranking
    ranking = User.all.order(:points).reverse
    for i in 0...ranking.count
      if ranking[i].id == self.id
        return i+1
      else
        # nothing to do
      end
    end
  end

  # name: total_accepted_questions
  # explanation: gets all right questions from a user
  # parameters:
  # - none
  # return: all right questions
  def total_accepted_questions
    all_right_questions = self.accepted_questions.count
    return all_right_questions
  end

  # name: data
  # explanation: creates info about all questions by area from user to use in system
  # parameters:
  # - none
  # return: none
  def data
    [
      ["Matemática", self.count_questions_by_area('matemática e suas tecnologias')],
      ["Natureza", self.count_questions_by_area('ciências da natureza e suas tecnologias')],
      ["Linguagens", self.count_questions_by_area('linguagens, códigos e suas tecnologias')],
      ["Humanas", self.count_questions_by_area('ciências humanas e suas tecnologias')]
    ]
  end

  # name: sum_exam_performance
  # explanation: creates info about the user's perfomance in all exams
  # parameters:
  # - none
  # return: exam performance updated
  def sum_exam_performance
    if self.exam_performance.empty?
      return 0
    else
      return self.exam_performance.inject(:+)
    end
  end

  # name: progress
  # explanation: checks a user's progress based on right questions by all questions
  # parameters:
  # - none
  # return: progress
  def progress
    progress_in_system = (100 * self.total_accepted_questions.to_f/Question.all.count).round(2)
    return progress_in_system
  end

  # name: battles
  # explanation: shows number of battles of a user
  # parameters:
  # - none
  # return: number of battles
  def battles
    battles = (self.active_battles + self.passive_battles).sort
    return battles
  end

  # name: average_performance
  # explanation: shows average performance in a given area by right questions by tried questions
  # parameters:
  # - area: String that represents the area of a question
  # return: average performance or 0.0
  def average_performance(area)
    accepted_questions = []
    tried_questions = []
    self.accepted_questions.each do |question_id|
      question_found = Question.find(question_id)
      if question_found.area == area
        accepted_questions << question_found
      else
        # nothing to do
      end
    end

    self.tried_questions.each do |question_id|
      question_found = Question.find(question_id)
      if question_found.area == area
        tried_questions << question_found
      else
        # nothing to do
      end
    end
    result = accepted_questions.count.to_f / tried_questions.count
    if result.nan?
      return 0.0
    else
      return result
    end
  end

  # name: classification
  # explanation:
  # parameters:
  # - area: String that represents the area of a question
  # return: String that specifies how good the user is
  def classification(area)
    performance = self.average_performance area
    performance *= 100


    if performance >= NONE && performance <= BEGGINER
     return "beginner"
   elsif performance > BEGGINER && performance <= INTERMEDIATE
     return "intermediate"
    else
     return "advanced"
    end
  end

end
