# File: exam.rb
# Purpose: Maintain logic for exam.
# License: LGPL. No copyright.

# This model lists the questions that were answered by exam users.

class Exam < ActiveRecord::Base

  serialize :questions, Array
  serialize :right_answers, Array
  serialize :user_answers, Array
  validates :questions, presence: true
  validates :right_answers, presence: true

end
