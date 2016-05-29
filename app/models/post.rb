# File: post.rb
# Purpose: Implementation of the class Post
# License: LGPL. No copyright.

# This class contains the core of a post section in the system. It contains
# attributes to interact with user posts, in addition to manage how many posts a
# user has

class Post < ActiveRecord::Base

  has_many :comments

  belongs_to :topic
  belongs_to :user

  validates :content, presence: true

  serialize :user_ratings, Array

  # name: count_post_rates
  # explanation: counts how many people have rated a post
  # parameters:
  # - none
  # return: an integer as described above
  def count_post_rates
    return self.user_ratings.count
  end

end
