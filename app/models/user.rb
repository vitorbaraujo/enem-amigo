class User < ActiveRecord::Base

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

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    BCrypt::Password.create(string, cost: cost)
  end

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

  def total_accepted_questions
    all_right_questions = self.accepted_questions.count
    return all_right_questions
  end

  def data
    [
      ["Matemática", self.count_questions_by_area('matemática e suas tecnologias')],
      ["Natureza", self.count_questions_by_area('ciências da natureza e suas tecnologias')],
      ["Linguagens", self.count_questions_by_area('linguagens, códigos e suas tecnologias')],
      ["Humanas", self.count_questions_by_area('ciências humanas e suas tecnologias')]
    ]
  end

  def sum_exam_performance
    if self.exam_performance.empty?
      return 0
    else
      return self.exam_performance.inject(:+)
    end
  end

  def progress
    progress_in_system = (100 * self.total_accepted_questions.to_f/Question.all.count).round(2)
    return progress_in_system
  end

  def battles
    return (self.active_battles + self.passive_battles).sort
  end

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

  def classification(area)
    performance = self.average_performance area
    performance *= 100
    if performance >= 0 && performance <= 30
     return "beginner"
    elsif performance > 30 && performance <= 60
     return "intermediate"
    else
     return "advanced"
    end
  end

end
