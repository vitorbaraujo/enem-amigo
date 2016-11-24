require 'test_helper'
require 'rails/performance_test_help'
 
class ExamModelTest < ActionDispatch::PerformanceTest
  def test_creation_exam
    Exam.create :questions => ["How are you?", "How much?"], :right_answers => ["Fine", "10"]
  end
end