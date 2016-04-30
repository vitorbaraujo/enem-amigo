class NotificationsController < ApplicationController

  def index
    @notifications = current_user.notifications.reverse
    return @notifications
  end

  def read
    render(:nothing => true)
    @notifications = current_user.notifications.where(visualized: false)
    @notifications.each do |notification|
      assert(notification.kind_of?(Notification))
      notification.update_attribute(:visualized, true)
    end
  end

end
