require 'test_helper'
require 'rails/performance_test_help'
 
class AlternativeModelTest < ActionDispatch::PerformanceTest

  def test_alternative_creation
    Alternative.create(letter: 'a', description: 'some text')
  end

end