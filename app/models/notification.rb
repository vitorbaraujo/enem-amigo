# File: notification.rb
# Purpose: Implementation of notification's class, to maintain relations to
# battle and users classes
# License : LGPL. No copyright.

# Notifications are the way for the system to show new battles between users.
# This model only implements validations regarding presence of message

class Notification < ActiveRecord::Base

  belongs_to :battle
  belongs_to :user
  validates :message, presence: true

end
