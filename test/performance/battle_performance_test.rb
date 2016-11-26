require 'test_helper'
require 'rails/performance_test_help'
 
class BattleModelTest < ActionDispatch::PerformanceTest

  def test_battle_creation
    Battle.create(player_2: users(:renata))
  end

  def test_battle_generate_questions
    battles(:first_battle).generate_questions
  end

  def test_battle_all_played
    battles(:first_battle).all_played?
  end

end