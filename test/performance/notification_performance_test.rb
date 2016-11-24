require 'test_helper'
require 'rails/performance_test_help'
 
class NotificationModelTest < ActionDispatch::PerformanceTest
  def test_creation_notification
    Notification.create 
  end
end