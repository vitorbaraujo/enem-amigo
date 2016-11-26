require 'test_helper'
require 'rails/performance_test_help'
 
class CandidateModelTest < ActionDispatch::PerformanceTest

  def test_candidate_creation
    Candidate.create(general_average: 0.6)
  end

end