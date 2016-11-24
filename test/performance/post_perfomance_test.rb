require 'test_helper'
require 'rails/performance_test_help'
 
class PostModelTest < ActionDispatch::PerformanceTest
  def test_creation_post
    Post.create :content => "hello"
  end

  def test_count_post_rates
 	posts(:post01).count_post_rates
  end
end