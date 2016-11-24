require 'test_helper'
require 'rails/performance_test_help'
 
class MedalModelTest < ActionDispatch::PerformanceTest
  def test_creation_medal
    Medal.create :name => "Medal 1"
  end

  def test_instructions_work
  	medals(:first_medal).instructions_work
  end

  def test_instructions_return_valid_class
  	medals(:first_medal).instructions_return_valid_class(medals(:first_medal).achieved_instructions,
  		medals(:first_medal).message_instructions)
  end

  def test_achieved
  	medals(:first_medal).achieved?(users(:renata))
  end

  def test_message
  	medals(:first_medal).message(users(:renata))
  end
end