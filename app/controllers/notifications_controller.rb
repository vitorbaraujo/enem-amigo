class NotificationsController < ApplicationController

  # name: index
  # explanation: this method gets notifications from user
  # parameters:
  # - none
  # return: notifications from user
  def index
    @notifications = current_user.notifications.reverse
    return @notifications
  end

  # name: read
  # explanation: this method updates status of notifications to seen by user
  # parameters:
  # - none
  # return: none
  def read
    render(:nothing => true)
    @notifications = current_user.notifications.where(visualized: false)
    @notifications.each do |notification|
      assert(notification.kind_of?(Notification))
      notification.update_attribute(:visualized, true)
    end
  end

end
