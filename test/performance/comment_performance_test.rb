require 'test_helper'
require 'rails/performance_test_help'
 
class CommentModelTest < ActionDispatch::PerformanceTest

  def test_comment_creation
    Comment.create(content: 'some text')
  end

  def test_comment_count_comment_rates
    comments(:first).count_comment_rates
  end

end